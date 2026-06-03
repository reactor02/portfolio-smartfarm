package kr.or.smartfarm.shipment;

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
     * 출하지시 — SHIPMENT 레코드 생성 + FIFO LOT 배정 + 요청 상태 변경.
     *
     * <p>재고가 계획 수량에 미달하면 가용 LOT까지만 부분 배정한다(사용자 정책상 허용).
     * {@code @Transactional}이므로 중간 실패 시 전체 롤백된다.</p>
     */
    @Override
    @Transactional
    public void dispatchShipment(Map map) {
        String shipmentRequestNum = (String) map.get("shipment_request_num");
        int itemNum  = (Integer) map.get("item_num");
        int planQty  = (Integer) map.get("plan_qty");
        int empNum   = (Integer) map.get("emp_num");

        // 1. Insert SHIPMENT record (selectKey gives back shipment_num)
        shipmentDAO.insertShipment(map);
        int shipmentNum = (Integer) map.get("shipment_num");

        // 2. FIFO LOT 배정
        List<Map> availableLots = shipmentDAO.getAvailableLots(itemNum);
        int remaining = planQty;
        for (Map lot : availableLots) {
            if (remaining <= 0) break;

            int lotNum     = ((Number) lot.get("LOT_NUM")).intValue();
            int currentQty = ((Number) lot.get("CURRENT_QTY")).intValue();
            int allocQty   = Math.min(remaining, currentQty);

            Map slMap = new HashMap();
            slMap.put("shipment_num", shipmentNum);
            slMap.put("lot_num",      lotNum);
            slMap.put("qty",          allocQty);
            shipmentDAO.insertShipmentLot(slMap);

            remaining -= allocQty;
        }

        // 3. Request status → 출하대기
        shipmentDAO.updateRequestStatusToDispatch(shipmentRequestNum);
    }

    /**
     * 출하확정 — 배정된 LOT을 실제 출고 처리한다.
     *
     * <p>출하 수량이 LOT 보유 수량보다 적으면 자식 LOT으로 분할하여
     * 롯이력 추적(lot_relation)이 출하까지 따라가도록 한다.</p>
     *
     * <p>[방어] 더블클릭/새로고침으로 인한 중복 확정을 막기 위해
     * "출하대기 → 출하완료" 상태 변경을 가장 먼저 실행해 해당 건을 선점(claim)한다.
     * 이미 확정/취소된 건이면 상태 UPDATE의 영향 행이 0이므로 즉시 종료한다.
     * @Transactional 이므로 이후 단계에서 예외가 나면 이 선점도 함께 롤백된다.</p>
     */
    @Override
    @Transactional
    public void confirmShipment(Map map) {
        int    shipmentNum        = (Integer) map.get("shipment_num");
        String shipmentRequestNum = (String)  map.get("shipment_request_num");
        int    empNum             = (Integer) map.get("emp_num");

        // [0] 중복 확정 방지 — '출하대기' 상태를 먼저 선점(claim)
        //     이미 확정/취소된 건이면 영향 행 0 → 무작업 종료(재고 이중 차감 차단)
        int claimed = shipmentDAO.confirmShipmentStatus(shipmentNum);
        if (claimed == 0) return;

        // 1. LOT별 수량 처리 (분할 or 직접 출고)
        List<Map> lots = shipmentDAO.getShipmentLots(shipmentNum);
        for (Map lot : lots) {
            int lotNum     = ((Number) lot.get("LOT_NUM")).intValue();
            int qty        = ((Number) lot.get("QTY")).intValue();
            int currentQty = ((Number) lot.get("CURRENT_QTY")).intValue();

            if (qty < currentQty) {
                // ── 분할: 출하 수량 < 보유 수량 ──

                // ① 자식 LOT 생성 (부모 expiry_date 상속)
                Map childMap = new HashMap();
                childMap.put("item_num",    ((Number) lot.get("ITEM_NUM")).intValue());
                childMap.put("qty",         qty);
                childMap.put("expiry_date", lot.get("EXPIRY_DATE"));
                shipmentDAO.insertSplitLot(childMap);
                int childLotNum = ((Number) childMap.get("lot_num")).intValue();

                // ② lot_split: 원본 → 분할 신규
                Map relMap = new HashMap();
                relMap.put("origin_lot_num", lotNum);
                relMap.put("split_lot_num",  childLotNum);
                shipmentDAO.insertLotSplit(relMap);

                // ③ 부모 LOT: IO 출고 (분할)
                Map parentIo = new HashMap();
                parentIo.put("lot_num",   lotNum);
                parentIo.put("qty",       qty);
                parentIo.put("emp_num",   empNum);
                parentIo.put("io_reason", "분할");
                shipmentDAO.insertShipmentIo(parentIo);

                // ④ 부모 LOT: 수량 차감
                //    [방어] deductLotQty는 current_qty >= qty 일 때만 차감(음수 재고 방지).
                //    영향 행이 0이면 보유 수량 부족 → 예외로 전체 트랜잭션 롤백.
                Map deductParent = new HashMap();
                deductParent.put("lot_num", lotNum);
                deductParent.put("qty",     qty);
                if (shipmentDAO.deductLotQty(deductParent) == 0) {
                    throw new RuntimeException("stock_error");
                }

                // ⑤ shipment_lot: 부모 → 자식 교체
                Map slUpdate = new HashMap();
                slUpdate.put("shipment_num",   shipmentNum);
                slUpdate.put("parent_lot_num", lotNum);
                slUpdate.put("child_lot_num",  childLotNum);
                shipmentDAO.updateShipmentLotRef(slUpdate);

                // ⑥ 자식 LOT: IO 출고 (출하)
                Map childIo = new HashMap();
                childIo.put("lot_num",   childLotNum);
                childIo.put("qty",       qty);
                childIo.put("emp_num",   empNum);
                childIo.put("io_reason", "출하");
                shipmentDAO.insertShipmentIo(childIo);

                // ⑦ 자식 LOT: 수량 차감 (→ 0)
                //    방금 생성한 LOT(current_qty=qty)이라 항상 성공하지만 일관성 위해 동일 검사
                Map deductChild = new HashMap();
                deductChild.put("lot_num", childLotNum);
                deductChild.put("qty",     qty);
                if (shipmentDAO.deductLotQty(deductChild) == 0) {
                    throw new RuntimeException("stock_error");
                }

            } else {
                // ── 분할 불필요: 수량 일치(qty == currentQty) ──
                //    [방어] qty > currentQty(과배정)인 경우에도 deductLotQty가 0을 반환하므로
                //    여기서 예외로 롤백된다(음수 재고 방지).
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

        // 2. 출하 상태 변경은 [0]에서 이미 선점 완료(중복 호출 제거)

        // 3. Request 상태 → 출하완료
        shipmentDAO.updateRequestStatusToComplete(shipmentRequestNum);
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
}
