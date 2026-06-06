package kr.or.smartfarm.shipment;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 출하 서비스 구현체.
 *
 * <p>조회 메서드는 DAO로 위임하고, dispatch/confirm/cancel 3개는 {@code @Transactional}로
 * 묶인 핵심 비즈니스 로직이다. 특히 confirm/cancel에는 중복 확정·음수 재고·확정 후 취소를
 * 막는 방어코딩(claim-first 선점, 차감 영향 행 검사, 상태 가드)이 적용되어 있다.</p>
 */
@Service
public class ShipmentServiceImpl implements ShipmentService {

    /** 출하 데이터 접근 DAO */
    @Autowired
    ShipmentDAO shipmentDAO;

    @Override
    public List selectAll(int pageNum) {
        return shipmentDAO.selectAll(pageNum);
    }

    @Override
    public List searchShipment(Map map) {
        return shipmentDAO.searchShipment(map);
    }

    @Override
    public Map selectDetail(String shipmentId) {
        return shipmentDAO.selectDetail(shipmentId);
    }

    @Override
    public List selectLots(int shipmentNum) {
        return shipmentDAO.selectLots(shipmentNum);
    }

    /**
     * 출하지시 — SHIPMENT 레코드(shell)만 생성하고 요청 상태를 '출하대기'로 변경한다.
     *
     * <p>예전에는 여기서 FIFO로 LOT을 자동 배정했으나, 이제 LOT 선택은 상세 페이지에서
     * 사용자가 수동으로 한다({@link #confirmShipmentManual}). 따라서 지시 시점에는
     * shipment_lot 행을 만들지 않는다. {@code @Transactional}이므로 실패 시 전체 롤백.</p>
     */
    @Override
    @Transactional
    public void dispatchShipment(Map map) {
        // 1. SHIPMENT 레코드 생성 (selectKey 로 shipment_num 채번, plan_qty 등은 map 에 포함)
        shipmentDAO.insertShipment(map);

        // 2. 요청 상태 → 출하대기 (자동 LOT 배정 없음)
        String shipmentRequestNum = (String) map.get("shipment_request_num");
        shipmentDAO.updateRequestStatusToDispatch(shipmentRequestNum);
    }

    /**
     * 출하취소 — '출하대기' 상태의 출하지시만 취소할 수 있다.
     *
     * <p>[방어] 이미 '출하완료'된 건은 재고가 차감되고 자식 LOT까지 생성된 상태라
     * 단순히 상태만 '취소'로 되돌리면 재고가 복구되지 않아 무결성이 깨진다.
     * 따라서 cancelShipmentStatus는 '출하대기' 건만 변경하며, 영향 행이 0이면
     * (확정/이미취소 등) request 상태도 건드리지 않고 종료한다.</p>
     */
    @Override
    @Transactional
    public void cancelShipment(Map map) {
        int    shipmentNum        = (Integer) map.get("shipment_num");
        String shipmentRequestNum = (String)  map.get("shipment_request_num");

        // 1. 출하 상태 → 취소 ('출하대기' 건만, 영향 행 0이면 취소 불가)
        int cancelled = shipmentDAO.cancelShipmentStatus(shipmentNum);
        if (cancelled == 0) return;

        // 2. Request 상태 → 접수 (롤백)
        shipmentDAO.updateRequestStatusToRollback(shipmentRequestNum);
    }

    @Override
    public List selectByRequestNum(String shipmentRequestNum) {
        return shipmentDAO.selectByRequestNum(shipmentRequestNum);
    }

    @Override
    public List loadItems() {
        return shipmentDAO.loadItems();
    }

    @Override
    public List loadPendingRequests() {
        return shipmentDAO.loadPendingRequests();
    }

    @Override
    public List loadEmpList() {
        return shipmentDAO.loadEmpList();
    }

    @Override
    public List loadWorkerList() {
        return shipmentDAO.loadWorkerList();
    }

    /** 출하 담당자 emp_num 조회 (취소/확정 권한 검증용) */
    @Override
    public String getEmpNum(String shipmentId) {
        return shipmentDAO.getEmpNum(shipmentId);
    }

    /** 출하 실무자 worker_num 조회 (출하확정 권한 검증용) */
    @Override
    public String getWorkerNum(String shipmentId) {
        return shipmentDAO.getWorkerNum(shipmentId);
    }

    /**
     * 선택한 LOT의 유통기한 검증.
     * 유통기한이 sysdate(현재)보다 이전이면 -1, 아니면 유통기한 그대로 반환한다.
     */
    @Override
    public Object selectLotExpiry(int lotNum) {
        Date expiry = shipmentDAO.getLotExpiry(lotNum);
        if (expiry.before(new Date())) {
            return -1;
        }
        return expiry;
    }

    /**
     * 출하에 배정된 LOT 중 유통기한이 sysdate보다 늦은(아직 안 지난, 유효한) 롯이
     * 하나라도 있으면 통과, 하나도 없으면 예외를 던진다.
     */
    @Override
    public void validateUsableLotExists(int shipmentNum) {
        List<Date> expiries = shipmentDAO.getShipmentLotExpiries(shipmentNum);
        Date now = new Date();
        for (Date expiry : expiries) {
            if (expiry.after(now)) {
                return; // 유통기한 안 지난(유효한) 롯이 하나라도 있으면 통과
            }
        }
        throw new RuntimeException("no_usable_lot");
    }

    /**
     * 출하 배정 전 LOT 검증.
     * 1) 품목 타입이 PRODUCT가 아니면 예외, 2) 이미 shipment_lot에 배정된 롯이면 예외.
     */
    @Override
    public void validateLotForShipment(int lotNum) {
        String type = shipmentDAO.getLotItemType(lotNum);
        if (type == null || !"PRODUCT".equalsIgnoreCase(type)) {
            throw new RuntimeException("not_product");
        }
        if (shipmentDAO.countShipmentLotByLotNum(lotNum) > 0) {
            throw new RuntimeException("already_allocated");
        }
    }

    /**
     * 후보 LOT 중 출하 가능한 롯만 골라 list로 모은다.
     * 하나도 없으면 예외를 던진다.
     */
    @Override
    public List<Integer> collectShippableLots(List<Integer> lotNums) {
        List<Integer> shippable = new ArrayList<Integer>();
        for (Integer lotNum : lotNums) {
            if (isShippableLot(lotNum)) {
                shippable.add(lotNum);
            }
        }
        if (shippable.isEmpty()) {
            throw new RuntimeException("no_shippable_lot");
        }
        return shippable;
    }

    /** PRODUCT 타입 + 미배정이면 출하 가능(true). validateLotForShipment와 동일 규칙(비throw 버전). */
    private boolean isShippableLot(int lotNum) {
        String type = shipmentDAO.getLotItemType(lotNum);
        if (type == null || !"PRODUCT".equalsIgnoreCase(type)) {
            return false;
        }
        return shipmentDAO.countShipmentLotByLotNum(lotNum) == 0;
    }

    /**
     * 해당 품목의 출하 가능 후보 LOT(FIFO)을 조회. 필터링은 SQL WHERE가 수행한다.
     * 상세 페이지 수동 선택 UI가 채울 목록이므로, 없으면 빈 리스트를 반환한다.
     */
    @Override
    public List<ShippableLotDTO> selectShippableLots(int itemNum) {
        List<ShippableLotDTO> lots = shipmentDAO.selectShippableLots(itemNum);
        return lots == null ? new ArrayList<ShippableLotDTO>() : lots;
    }

    /**
     * 출하확정(수동 LOT 선택). {@code @Transactional}.
     *
     * <p>검증 → claim-first 선점 → 선택별 출고/분할 → 요청 완료 순으로 처리한다.
     * 합계가 plan_qty 미만이면 force=true 일 때만 통과(부분출하 허용). 보유수량 초과 차감은
     * deductLotQty 가드(영향행 0)로 막혀 stock_error 로 전체 롤백된다.</p>
     */
    @Override
    @Transactional
    public void confirmShipmentManual(int shipmentNum, String shipmentRequestNum,
                                      int empNum, int planQty, List<Map> selections, boolean force) {
        // 1. 검증 (DB 변경 전)
        if (selections == null || selections.isEmpty()) {
            throw new RuntimeException("empty_selection");
        }
        int total = 0;
        for (Map sel : selections) {
            int qty = ((Number) sel.get("qty")).intValue();
            if (qty <= 0) throw new RuntimeException("invalid_qty");
            total += qty;
        }
        if (total > planQty) throw new RuntimeException("over_plan");
        if (total < planQty && !force) throw new RuntimeException("under_plan");

        // 2. claim-first — '출하대기' 선점(중복 확정 방지). 이미 확정/취소면 영향행 0 → 종료
        int claimed = shipmentDAO.confirmShipmentStatus(shipmentNum);
        if (claimed == 0) return;

        // 3. 선택별 출고/분할
        for (Map sel : selections) {
            int lotNum = ((Number) sel.get("lot_num")).intValue();
            int qty    = ((Number) sel.get("qty")).intValue();

            // shipment_lot 기록 (지시 단계에서 자동배정하지 않으므로 여기서 생성)
            Map slMap = new HashMap();
            slMap.put("shipment_num", shipmentNum);
            slMap.put("lot_num",      lotNum);
            slMap.put("qty",          qty);
            shipmentDAO.insertShipmentLot(slMap);

            Map lot = shipmentDAO.selectLotForConfirm(lotNum);
            int currentQty = ((Number) lot.get("CURRENT_QTY")).intValue();

            if (qty < currentQty) {
                // ── 분할: 출하 수량 < 보유 수량 ──
                Map childMap = new HashMap();
                childMap.put("item_num",    ((Number) lot.get("ITEM_NUM")).intValue());
                childMap.put("qty",         qty);
                childMap.put("expiry_date", lot.get("EXPIRY_DATE"));
                shipmentDAO.insertSplitLot(childMap);
                int childLotNum = ((Number) childMap.get("lot_num")).intValue();

                Map relMap = new HashMap();
                relMap.put("origin_lot_num", lotNum);
                relMap.put("split_lot_num",  childLotNum);
                shipmentDAO.insertLotSplit(relMap);

                Map parentIo = new HashMap();
                parentIo.put("lot_num",   lotNum);
                parentIo.put("qty",       qty);
                parentIo.put("emp_num",   empNum);
                parentIo.put("io_reason", "분할");
                shipmentDAO.insertShipmentIo(parentIo);

                Map deductParent = new HashMap();
                deductParent.put("lot_num", lotNum);
                deductParent.put("qty",     qty);
                if (shipmentDAO.deductLotQty(deductParent) == 0) {
                    throw new RuntimeException("stock_error");
                }

                Map slUpdate = new HashMap();
                slUpdate.put("shipment_num",   shipmentNum);
                slUpdate.put("parent_lot_num", lotNum);
                slUpdate.put("child_lot_num",  childLotNum);
                shipmentDAO.updateShipmentLotRef(slUpdate);

                Map childIo = new HashMap();
                childIo.put("lot_num",   childLotNum);
                childIo.put("qty",       qty);
                childIo.put("emp_num",   empNum);
                childIo.put("io_reason", "출하");
                shipmentDAO.insertShipmentIo(childIo);

                Map deductChild = new HashMap();
                deductChild.put("lot_num", childLotNum);
                deductChild.put("qty",     qty);
                if (shipmentDAO.deductLotQty(deductChild) == 0) {
                    throw new RuntimeException("stock_error");
                }

            } else {
                // ── 직접 출고: qty == currentQty (qty > currentQty 면 deduct 0 → stock_error) ──
                Map deductMap = new HashMap();
                deductMap.put("lot_num", lotNum);
                deductMap.put("qty",     qty);
                if (shipmentDAO.deductLotQty(deductMap) == 0) {
                    throw new RuntimeException("stock_error");
                }

                Map ioMap = new HashMap();
                ioMap.put("lot_num",   lotNum);
                ioMap.put("qty",       qty);
                ioMap.put("emp_num",   empNum);
                ioMap.put("io_reason", "출하");
                shipmentDAO.insertShipmentIo(ioMap);
            }
        }

        // 4. 요청 상태 → 출하완료
        shipmentDAO.updateRequestStatusToComplete(shipmentRequestNum);
    }
}
