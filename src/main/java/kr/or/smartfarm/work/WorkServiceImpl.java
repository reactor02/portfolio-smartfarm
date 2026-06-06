package kr.or.smartfarm.work;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.smartfarm.bom.BomDTO;
import kr.or.smartfarm.lot.LotDAO;
import kr.or.smartfarm.lot.LotDTO;
import kr.or.smartfarm.lot.LotRelationDAO;
import kr.or.smartfarm.lot.LotRelationDTO;
import kr.or.smartfarm.prod.ProdDAO;
import kr.or.smartfarm.prod.ProdDTO;
import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class WorkServiceImpl implements WorkService {

    @Autowired
    private WorkDAO dao;

    @Autowired
    private ProdDAO prodDao;

    @Autowired
    private LotDAO lotDao;

    @Autowired
    private LotRelationDAO lotRelationDao;

    @Override
    public List<WorkDTO> getList(WorkPageDTO page) {
        int startRow = (page.getPage() - 1) * page.getSize() + 1;
        int endRow   =  page.getPage()      * page.getSize();
        page.setStartRow(startRow);
        page.setEndRow(endRow);

        List<WorkDTO> list = dao.getList(page);

        if (list != null && !list.isEmpty()) {
            int totalCount = list.get(0).getTotal_count();
            int totalPages = (int) Math.ceil((double) totalCount / page.getSize());
            int startPage  = (((page.getPage() - 1) / page.getBlockSize()) * page.getBlockSize()) + 1;
            int endPage    = Math.min(startPage + page.getBlockSize() - 1, totalPages);

            page.setTotalCount(totalCount);
            page.setTotalPages(totalPages);
            page.setStartPage(startPage);
            page.setEndPage(endPage);
        }
        return list;
    }

    @Override
    public WorkDTO selectOne(String work_order_id) {
        return dao.getSelectOne(work_order_id);
    }

    @Override
    public int create(WorkDTO workDTO) {
        return dao.create(workDTO);
    }

    @Override
    public void cancel(String work_order_id) {
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dto.setWork_status("취소");
        dao.updateStatus(dto);
    }

    @Override
    public void start(String work_order_id) {
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dto.setWork_status("진행");
        dao.updateStatus(dto);
    }

    @Override
    public void complete(String work_order_id) {
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dto.setWork_status("완료");
        dao.updateStatus(dto);
    }

    @Override
    public void input(String work_order_id, int qty) {
        // [0][방어] 식별자 누락 차단
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            throw new IllegalArgumentException("work order not found: " + work_order_id);
        }

        int itemNum  = work.getItem_num();
        int orderNum = work.getOrder_num();
        int planNum  = work.getPlan_num();

        // [1] 입력 수량 검증 — 1 이상, min(재고기준 최대, 미투입 잔여) 이하만 허용 (서버 권위 재계산)
        Map<String, Object> info = computeProduceInfo(work);
        int maxInput = (int) info.get("maxInput");
        if (qty < 1 || qty > maxInput) {
            throw new RuntimeException("qty_error");
        }

        // [2] BOM 자재별 FIFO(QC합격·유통기한 유효) 차감 + io 출고 + order_lot 기록 + stock 차감
        List<BomDTO> materials = dao.getMaterialsByItem(itemNum);
        for (BomDTO mat : materials) {
            int totalNeeded = mat.getRequired_qty() * qty;
            List<LotDTO> lots = lotDao.getQcPassedLotsFIFO(mat.getItem_num2());

            for (LotDTO lot : lots) {
                if (totalNeeded <= 0) break;
                int deduct = Math.min(lot.getCurrent_qty(), totalNeeded);

                // ① lot 수량 차감
                lotDao.deductQty(lot.getLot_num(), deduct);

                // ② io 출고 기록 (생산투입)
                Map<String, Object> ioMap = new HashMap<String, Object>();
                ioMap.put("ioType",   "출고");
                ioMap.put("ioQty",    deduct);
                ioMap.put("qcNum",    lot.getQc_num());
                ioMap.put("lotNum",   lot.getLot_num());
                ioMap.put("planNum",  planNum);
                ioMap.put("ioReason", "생산투입");
                dao.insertIo(ioMap);

                // ③ order_lot 기록 — 이 작업지시에 묶인 출고 LOT
                Map<String, Object> olMap = new HashMap<String, Object>();
                olMap.put("order_num", orderNum);
                olMap.put("lot_num",   lot.getLot_num());
                olMap.put("qty",       deduct);
                dao.insertOrderLot(olMap);

                totalNeeded -= deduct;
            }

            // 자재 stock 차감 (stock 행이 있을 때만 반영)
            Map<String, Object> stockOutMap = new HashMap<String, Object>();
            stockOutMap.put("itemNum", mat.getItem_num2());
            stockOutMap.put("qty",     -(mat.getRequired_qty() * qty));
            dao.adjustStock(stockOutMap);
        }

        // [3] 누적 투입수량 증가
        Map<String, Object> inputMap = new HashMap<String, Object>();
        inputMap.put("work_order_id", work_order_id);
        inputMap.put("delta",         qty);
        dao.addInputQty(inputMap);
    }

    @Override
    public void produce(String work_order_id) {
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            throw new IllegalArgumentException("work order not found: " + work_order_id);
        }

        int itemNum  = work.getItem_num();
        int orderNum = work.getOrder_num();
        String type  = work.getType();

        // 생산할 수량 = 투입수량 − 이미 생산된 수량 (미생산 투입분)
        int producedNow = work.getInput_qty() - work.getCurrent_qty();
        if (producedNow <= 0) {
            throw new RuntimeException("nothing");   // 먼저 생산투입 필요
        }

        // [1] 완제품 LOT 생성 (자재는 이미 생산투입에서 차감됨 → 재차감 없음)
        LotDTO newLot = new LotDTO();
        newLot.setItem_num(itemNum);
        newLot.setOrder_num(orderNum);
        newLot.setInit_qty(producedNow);
        newLot.setCurrent_qty(producedNow);
        newLot.setType(type);
        lotDao.insertLot(newLot);
        int newLotNum = newLot.getLot_num();

        // [2] 생산입고 io 기록
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("ioQty",    producedNow);
        inMap.put("lotNum",   newLotNum);
        inMap.put("itemType", type);
        inMap.put("empNum",   work.getWorker_num());
        dao.insertProduceIo(inMap);

        // [3] 완제품 stock 증가
        Map<String, Object> stockInMap = new HashMap<String, Object>();
        stockInMap.put("itemNum", itemNum);
        stockInMap.put("qty",     producedNow);
        dao.adjustStock(stockInMap);

        // [4] lot_relation — 완제품(parent) ↔ 투입된 자재 LOT(child) 연결
        for (Map<String, Object> ol : dao.getOrderLots(orderNum)) {
            int childLot = ((Number) ol.get("LOT_NUM")).intValue();
            LotRelationDTO rel = new LotRelationDTO();
            rel.setParent_lot_num(newLotNum);
            rel.setChild_lot_num(childLot);
            lotRelationDao.insert(rel);
        }

        // [5] current_qty 증분 + 지시수량 도달 시 완료 처리
        Map<String, Object> produceMap = new HashMap<String, Object>();
        produceMap.put("work_order_id", work_order_id);
        produceMap.put("qty",           producedNow);
        dao.produce(produceMap);
        dao.completePlanIfDone(work_order_id);
    }

    @Override
    public void cancelInput(String work_order_id) {
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            throw new IllegalArgumentException("work order not found: " + work_order_id);
        }

        // 환원 대상 = 미생산 투입분 (이미 완제품으로 소모된 분량은 환원 안 함)
        int remainingUnits = work.getInput_qty() - work.getCurrent_qty();
        if (remainingUnits <= 0) return;

        int orderNum = work.getOrder_num();

        // 자재(item)별 환원량 = required_qty × remainingUnits
        Map<Integer, Integer> restoreByItem = new HashMap<Integer, Integer>();
        for (BomDTO mat : dao.getMaterialsByItem(work.getItem_num())) {
            restoreByItem.put(mat.getItem_num2(), mat.getRequired_qty() * remainingUnits);
        }

        // order_lot LIFO 순회하며 자재별 환원량을 채울 때까지 LOT/stock 환원 + order_lot 정리
        for (Map<String, Object> ol : dao.getOrderLotsForCancel(orderNum)) {
            int orderLotNum = ((Number) ol.get("ORDER_LOT_NUM")).intValue();
            int lotNum      = ((Number) ol.get("LOT_NUM")).intValue();
            int rowQty      = ((Number) ol.get("QTY")).intValue();
            int itemNum     = ((Number) ol.get("ITEM_NUM")).intValue();

            Integer left = restoreByItem.get(itemNum);
            if (left == null || left <= 0) continue;

            int take = Math.min(rowQty, left);

            // LOT 수량 환원 + stock 환원 + io 역기록(입고·투입취소)
            Map<String, Object> restoreMap = new HashMap<String, Object>();
            restoreMap.put("lot_num", lotNum);
            restoreMap.put("qty",     take);
            dao.restoreLotQty(restoreMap);

            Map<String, Object> stockMap = new HashMap<String, Object>();
            stockMap.put("itemNum", itemNum);
            stockMap.put("qty",     take);
            dao.adjustStock(stockMap);

            Map<String, Object> ioMap = new HashMap<String, Object>();
            ioMap.put("ioType",   "입고");
            ioMap.put("ioQty",    take);
            ioMap.put("qcNum",    0);
            ioMap.put("lotNum",   lotNum);
            ioMap.put("planNum",  work.getPlan_num());
            ioMap.put("ioReason", "투입취소");
            dao.insertIo(ioMap);

            // order_lot 정리: 전량이면 삭제, 부분이면 qty 감소
            if (take >= rowQty) {
                dao.deleteOrderLot(orderLotNum);
            } else {
                Map<String, Object> redMap = new HashMap<String, Object>();
                redMap.put("order_lot_num", orderLotNum);
                redMap.put("qty",           take);
                dao.reduceOrderLot(redMap);
            }

            restoreByItem.put(itemNum, left - take);
        }

        // 누적 투입수량을 생산된 수량까지 되돌림 (input_qty == current_qty)
        Map<String, Object> inputMap = new HashMap<String, Object>();
        inputMap.put("work_order_id", work_order_id);
        inputMap.put("delta",         -remainingUnits);
        dao.addInputQty(inputMap);
    }

    @Override
    public Map<String, Object> getProduceInfo(String work_order_id) {
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            // 존재하지 않으면 빈 정보 반환 (상세 컨트롤러에서 이미 null 가드 처리됨)
            Map<String, Object> empty = new HashMap<String, Object>();
            empty.put("materials",      new java.util.ArrayList<Map<String, Object>>());
            empty.put("remaining",      0);
            empty.put("maxProducible",  0);
            empty.put("inputtable",     0);
            empty.put("maxInput",       0);
            empty.put("pendingProduce", 0);
            empty.put("input_qty",      0);
            return empty;
        }
        return computeProduceInfo(work);
    }

    @Override
    public List<Map<String, Object>> getOrderLots(int order_num) {
        return dao.getOrderLots(order_num);
    }

    /**
     * 소모자재/재고/투입·생산 가능 수량을 계산한다. (상세 표시 + input 서버 검증 공용)
     * - 잔여수량(remaining)   = order_qty - current_qty (표시용, 음수면 0)
     * - 미투입 잔여(inputtable) = order_qty - input_qty (추가 투입 가능 한도)
     * - 자재별 가용재고 = QC 합격 FIFO LOT current_qty 합계 (실제 차감 소스와 동일)
     * - 필요수량 = 단위소요량 × 잔여수량,  부족분 = max(0, 필요 - 가용)
     * - maxProducible(재고기준) = min(잔여, 각 자재 floor(가용/단위소요량))
     * - maxInput = min(inputtable, 재고기준 maxProducible)
     * - pendingProduce = input_qty - current_qty (작업완료로 생산할 수량)
     */
    private Map<String, Object> computeProduceInfo(WorkDTO work) {
        int remaining = work.getOrder_qty() - work.getCurrent_qty();
        if (remaining < 0) remaining = 0;
        int inputtable = work.getOrder_qty() - work.getInput_qty();
        if (inputtable < 0) inputtable = 0;

        List<BomDTO> materials = dao.getBomMaterialsDetail(work.getItem_num());

        List<Map<String, Object>> matList = new java.util.ArrayList<Map<String, Object>>();
        int maxProducible = remaining;   // 자재가 없으면 잔여수량까지 가능

        for (BomDTO mat : materials) {
            int unitQty = mat.getRequired_qty();

            // 가용재고: QC 합격 FIFO LOT current_qty 합계
            int available = 0;
            for (LotDTO l : lotDao.getQcPassedLotsFIFO(mat.getItem_num2())) {
                available += l.getCurrent_qty();
            }

            int needQty  = unitQty * remaining;
            int shortage = Math.max(0, needQty - available);

            if (unitQty > 0) {
                int perMatMax = available / unitQty;
                if (perMatMax < maxProducible) maxProducible = perMatMax;
            }

            Map<String, Object> m = new HashMap<String, Object>();
            m.put("name",      mat.getName());
            m.put("code",      mat.getCode());
            m.put("unitQty",   unitQty);
            m.put("needQty",   needQty);
            m.put("available", available);
            m.put("shortage",  shortage);
            matList.add(m);
        }

        if (maxProducible < 0) maxProducible = 0;
        int maxInput = Math.min(inputtable, maxProducible);
        int pendingProduce = work.getInput_qty() - work.getCurrent_qty();
        if (pendingProduce < 0) pendingProduce = 0;

        Map<String, Object> info = new HashMap<String, Object>();
        info.put("materials",      matList);
        info.put("remaining",      remaining);
        info.put("maxProducible",  maxProducible);
        info.put("inputtable",     inputtable);
        info.put("maxInput",       maxInput);
        info.put("pendingProduce", pendingProduce);
        info.put("input_qty",      work.getInput_qty());
        return info;
    }

    @Override
    public List<SelectOptionDTO> getEmpOptions() {
        return dao.getEmpOptions();
    }

    @Override
    public List<SelectOptionDTO> getWorkerOptions() {
        return dao.getWorkerOptions();
    }

    @Override
    public List<SelectOptionDTO> getPlanOptions() {
        return dao.getPlanOptions();
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return dao.getItemOptions();
    }

    @Override
    public List<Map<String, Object>> getProcessesByItem(int item_num) {
        return dao.getProcessesByItem(item_num);
    }

    @Override
    public Map<String, Object> searchPlans(String keyword, int page) {
        prodDao.syncPlanStatus();   // plan_start 지난 대기 → 진행 동기화
        int size     = 5;
        int startRow = (page - 1) * size + 1;
        int endRow   = page * size;

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("keyword",  keyword);
        params.put("startRow", startRow);
        params.put("endRow",   endRow);

        List<ProdDTO> list       = dao.searchPlans(params);
        int totalCount = (list != null && !list.isEmpty()) ? list.get(0).getTotal_count() : 0;
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / size);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("list",        list);
        result.put("currentPage", page);
        result.put("totalPages",  totalPages);
        result.put("totalCount",  totalCount);
        return result;
    }

    @Override
    public Map<String, Object> searchWorkers(String keyword, int page) {
        int size     = 5;
        int startRow = (page - 1) * size + 1;
        int endRow   = page * size;

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("keyword",  keyword);
        params.put("startRow", startRow);
        params.put("endRow",   endRow);

        List<Map<String, Object>> list = dao.searchWorkers(params);
        int totalCount = 0;
        if (list != null && !list.isEmpty()) {
            Object tc = list.get(0).get("TOTAL_COUNT");
            if (tc != null) totalCount = ((Number) tc).intValue();
        }
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / size);

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("list",        list);
        result.put("currentPage", page);
        result.put("totalPages",  totalPages);
        result.put("totalCount",  totalCount);
        return result;
    }

    /** 작업지시 담당자 emp_num 조회 (취소/완료 권한 검증용) */
    @Override
    public String getEmpNum(String work_order_id) {
        return dao.getEmpNum(work_order_id);
    }

    /** 작업지시 실무자 worker_num 조회 (시작/완료/생산 권한 검증용) */
    @Override
    public String getWorkerNum(String work_order_id) {
        return dao.getWorkerNum(work_order_id);
    }
}
