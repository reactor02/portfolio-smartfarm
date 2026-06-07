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
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            throw new IllegalArgumentException("work order not found: " + work_order_id);
        }
        // 상태 대기→진행
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dto.setWork_status("진행");
        dao.updateStatus(dto);

        // 작업시작과 동시에 완제품 LOT 생성 (init_qty=NULL, current_qty=0)
        Map<String, Object> lotMap = new HashMap<String, Object>();
        lotMap.put("item_num",  work.getItem_num());
        lotMap.put("order_num", work.getOrder_num());
        lotMap.put("type",      work.getType());
        dao.insertProductLotStart(lotMap);
        Object lotNum = lotMap.get("lot_num");

        Map<String, Object> ref = new HashMap<String, Object>();
        ref.put("work_order_id", work_order_id);
        ref.put("lot_num",       lotNum);
        dao.setProductLotNum(ref);
    }

    @Override
    public void complete(String work_order_id) {
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dto.setWork_status("완료");
        dao.updateStatus(dto);
    }

    /* ════════════ 공정별(라우팅) 진행 상태머신 ════════════ */

    @Override
    public void ensureWorkProcesses(String work_order_id) {
        if (work_order_id == null || work_order_id.trim().isEmpty()) return;
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) return;
        int orderNum = work.getOrder_num();
        if (dao.countWorkProcesses(orderNum) > 0) return;   // 멱등
        insertCycleProcesses(work, 1);   // 최초 1회차 공정 행 생성
    }

    /** 지정 회차(cycle)의 공정 행을 품목 공정 수만큼 '대기'로 INSERT */
    private void insertCycleProcesses(WorkDTO work, int cycleNo) {
        int orderNum = work.getOrder_num();
        for (Map<String, Object> p : dao.getProcessesByItem(work.getItem_num())) {
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("order_num",   orderNum);
            row.put("process_num", toInt(p.get("PROCESS_NUM")));
            row.put("flow",        p.get("FLOW") == null ? null : toInt(p.get("FLOW")));
            row.put("cycle_no",    cycleNo);
            dao.insertWorkProcess(row);
        }
    }

    @Override
    public Map<String, Object> getMaxInfo(String work_order_id) {
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            Map<String, Object> empty = new HashMap<String, Object>();
            empty.put("maxProducible", 0);
            empty.put("materials", new java.util.ArrayList<Map<String, Object>>());
            return empty;
        }
        return computeMaxProducible(work);
    }

    @Override
    public void inputProcessMaterial(String work_order_id, int process_num, int qty) {
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) {
            throw new IllegalArgumentException("work order not found: " + work_order_id);
        }
        int orderNum = work.getOrder_num();

        // [게이트] 작업이 '진행' 상태 + 대상 공정이 현재 활성('대기')이어야 함
        if (!"진행".equals(work.getWork_status())) throw new RuntimeException("state_error");
        Map<String, Object> active = findActiveProcess(orderNum);
        if (active == null) throw new RuntimeException("state_error");
        if (toInt(active.get("PROCESS_NUM")) != process_num) throw new RuntimeException("state_error");
        if (!"대기".equals(active.get("STATUS"))) throw new RuntimeException("state_error");

        // [수량] 첫 투입이면 배치 생산수량 확정(1 ≤ qty ≤ 최대생산량), 이후 공정은 확정 수량 사용
        int batchQty = work.getInput_qty();
        if (batchQty <= 0) {
            int maxProducible = (int) computeMaxProducible(work).get("maxProducible");
            if (qty < 1 || qty > maxProducible) {
                throw new RuntimeException("qty_error");
            }
            batchQty = qty;
            Map<String, Object> sq = new HashMap<String, Object>();
            sq.put("work_order_id", work_order_id);
            sq.put("qty",           batchQty);
            dao.setInputQty(sq);
        }

        int wpNum = toInt(active.get("WORK_PROCESS_NUM"));

        // [차감] 해당 공정 BOM 자재 × batchQty FIFO 차감 + io 출고 + work_process_lot 기록 + stock 차감
        for (BomDTO mat : dao.getProcessMaterials(process_num)) {
            int totalNeeded = mat.getRequired_qty() * batchQty;
            for (LotDTO lot : lotDao.getQcPassedLotsFIFO(mat.getItem_num2())) {
                if (totalNeeded <= 0) break;
                int deduct = Math.min(lot.getCurrent_qty(), totalNeeded);

                lotDao.deductQty(lot.getLot_num(), deduct);

                Map<String, Object> ioMap = new HashMap<String, Object>();
                ioMap.put("ioType",   "출고");
                ioMap.put("ioQty",    deduct);
                ioMap.put("qcNum",    lot.getQc_num());
                ioMap.put("lotNum",   lot.getLot_num());
                ioMap.put("planNum",  work.getPlan_num());
                ioMap.put("ioReason", "생산투입");
                dao.insertIo(ioMap);

                Map<String, Object> wplMap = new HashMap<String, Object>();
                wplMap.put("work_process_num", wpNum);
                wplMap.put("lot_num",          lot.getLot_num());
                wplMap.put("item_num",         mat.getItem_num2());
                wplMap.put("qty",              deduct);
                dao.insertWorkProcessLot(wplMap);

                totalNeeded -= deduct;
            }
            Map<String, Object> stockOut = new HashMap<String, Object>();
            stockOut.put("itemNum", mat.getItem_num2());
            stockOut.put("qty",     -(mat.getRequired_qty() * batchQty));
            dao.adjustStock(stockOut);
        }

        // [상태] 대기 → 자재투입
        dao.setWorkProcessStatus(statusMap(orderNum, process_num, "자재투입"));
    }

    @Override
    public List<Map<String, Object>> previewProcessLots(String work_order_id, int process_num, int qty) {
        List<Map<String, Object>> result = new java.util.ArrayList<Map<String, Object>>();
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) return result;
        int batchQty = work.getInput_qty() > 0 ? work.getInput_qty() : qty;
        for (BomDTO mat : dao.getProcessMaterials(process_num)) {
            int needed = mat.getRequired_qty() * batchQty;
            for (LotDTO lot : lotDao.getQcPassedLotsFIFO(mat.getItem_num2())) {
                if (needed <= 0) break;
                int deduct = Math.min(lot.getCurrent_qty(), needed);
                Map<String, Object> row = new HashMap<String, Object>();
                row.put("item_name", mat.getName());
                row.put("lot_num",   lot.getLot_num());
                row.put("deduct",    deduct);
                result.add(row);
                needed -= deduct;
            }
        }
        return result;
    }

    @Override
    public void startProcess(String work_order_id, int process_num) {
        WorkDTO work = requireWork(work_order_id);
        Map<String, Object> active = findActiveProcess(work.getOrder_num());
        if (active == null || toInt(active.get("PROCESS_NUM")) != process_num) throw new RuntimeException("state_error");
        if (!"자재투입".equals(active.get("STATUS"))) throw new RuntimeException("state_error");
        dao.setWorkProcessStatus(statusMap(work.getOrder_num(), process_num, "진행"));
    }

    @Override
    public void completeProcess(String work_order_id, int process_num) {
        WorkDTO work = requireWork(work_order_id);
        int orderNum = work.getOrder_num();
        Map<String, Object> active = findActiveProcess(orderNum);
        if (active == null || toInt(active.get("PROCESS_NUM")) != process_num) throw new RuntimeException("state_error");
        if (!"진행".equals(active.get("STATUS"))) throw new RuntimeException("state_error");

        dao.setWorkProcessStatus(statusMap(orderNum, process_num, "완료"));

        // 최종 공정이면 완제품 LOT 확정 + 생산입고 + lot_relation + 생산완료수량 반영
        int maxFlow = maxFlow(orderNum);
        int thisFlow = active.get("FLOW") == null ? -1 : toInt(active.get("FLOW"));
        boolean isFinal = (thisFlow == maxFlow);
        if (isFinal) {
            int producedQty = work.getInput_qty();   // 생산완료수량 = 누적 투입수량
            Integer productLot = work.getProduct_lot_num();
            if (producedQty > 0 && productLot != null) {
                Map<String, Object> fin = new HashMap<String, Object>();
                fin.put("lot_num", productLot);
                fin.put("qty",     producedQty);
                dao.finalizeProductLot(fin);

                Map<String, Object> inMap = new HashMap<String, Object>();
                inMap.put("ioQty",    producedQty);
                inMap.put("lotNum",   productLot);
                inMap.put("itemType", work.getType());
                inMap.put("empNum",   work.getWorker_num());
                dao.insertProduceIo(inMap);

                Map<String, Object> stockIn = new HashMap<String, Object>();
                stockIn.put("itemNum", work.getItem_num());
                stockIn.put("qty",     producedQty);
                dao.adjustStock(stockIn);

                // 현재 회차에 투입된 자재 LOT만 계보 연결 (insert는 멱등 → 중복 방지)
                for (Map<String, Object> wpl : dao.getCurrentCycleProcessLots(orderNum)) {
                    LotRelationDTO rel = new LotRelationDTO();
                    rel.setParent_lot_num(productLot.intValue());
                    rel.setChild_lot_num(toInt(wpl.get("LOT_NUM")));
                    lotRelationDao.insert(rel);
                }

                Map<String, Object> cq = new HashMap<String, Object>();
                cq.put("work_order_id", work_order_id);
                cq.put("qty",           producedQty);
                dao.setCurrentQty(cq);
                dao.completePlanIfDone(work_order_id);
            }
        }
    }

    @Override
    public String completeWork(String work_order_id, boolean force) {
        WorkDTO work = requireWork(work_order_id);
        if (dao.countActiveProcess(work.getOrder_num()) > 0) return "in_progress";
        int current = work.getCurrent_qty();
        int order   = work.getOrder_qty();
        if (current >= order) {
            setStatus(work_order_id, "완료");
            return "ok";
        }
        if (!force) return "not_full";
        setStatus(work_order_id, "완료");
        return "ok";
    }

    @Override
    public void startNextCycle(String work_order_id) {
        WorkDTO work = requireWork(work_order_id);
        int orderNum = work.getOrder_num();
        // [게이트] 진행 상태 && 현재 회차 전 공정 완료(활성 공정 없음) && 지시수량 미달
        //  → 더블클릭/연타로 활성 공정이 남아있으면 새 회차를 만들지 않는다.
        if (!"진행".equals(work.getWork_status())) throw new RuntimeException("state_error");
        if (findActiveProcess(orderNum) != null) throw new RuntimeException("state_error");
        if (work.getCurrent_qty() >= work.getOrder_qty()) throw new RuntimeException("state_error");

        int nextCycle = dao.getCurrentCycleNo(orderNum) + 1;
        insertCycleProcesses(work, nextCycle);   // 새 회차 공정 행(대기) 생성

        Map<String, Object> rq = new HashMap<String, Object>();
        rq.put("work_order_id", work_order_id);
        dao.resetInputQty(rq);                    // 회차 배치수량 재확정을 위해 0으로
    }

    @Override
    public List<Map<String, Object>> getWorkProcesses(int order_num) {
        return dao.getWorkProcesses(order_num);
    }

    @Override
    public List<Map<String, Object>> getWorkProcessLots(int order_num) {
        return dao.getWorkProcessLots(order_num);
    }

    @Override
    public Map<String, Object> getActionState(String work_order_id) {
        Map<String, Object> result = new HashMap<String, Object>();
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) { result.put("allDone", false); result.put("action", "none"); return result; }
        result.put("workStatus",     work.getWork_status());
        result.put("currentCycleNo", dao.getCurrentCycleNo(work.getOrder_num()));
        Map<String, Object> active = findActiveProcess(work.getOrder_num());
        if (active == null) {
            // 현재 회차 전 공정 완료. 지시수량 미달이면 다음 회차 진행 가능.
            boolean canNextCycle = work.getCurrent_qty() < work.getOrder_qty();
            result.put("allDone",      true);
            result.put("action",       "done");
            result.put("canNextCycle", canNextCycle);
            return result;
        }
        result.put("canNextCycle", false);
        String st = (String) active.get("STATUS");
        String action = "대기".equals(st) ? "input"
                      : "자재투입".equals(st) ? "start"
                      : "진행".equals(st) ? "complete" : "none";
        result.put("allDone",          false);
        result.put("activeProcessNum", toInt(active.get("PROCESS_NUM")));
        result.put("activeFlow",       active.get("FLOW"));
        result.put("activeStatus",     st);
        result.put("action",           action);
        return result;
    }

    /* ── 내부 헬퍼 ── */

    /** 최대생산량(모든 BOM 자재 floor(FIFO가용/req)의 min, order_qty−current_qty로 cap) + 자재 정보 */
    private Map<String, Object> computeMaxProducible(WorkDTO work) {
        int remaining = work.getOrder_qty() - work.getCurrent_qty();
        if (remaining < 0) remaining = 0;

        List<BomDTO> materials = dao.getBomMaterialsDetail(work.getItem_num());
        List<Map<String, Object>> matList = new java.util.ArrayList<Map<String, Object>>();
        int maxProducible = remaining;

        for (BomDTO mat : materials) {
            int unitQty = mat.getRequired_qty();
            int available = 0;
            for (LotDTO l : lotDao.getQcPassedLotsFIFO(mat.getItem_num2())) {
                available += l.getCurrent_qty();
            }
            if (unitQty > 0) {
                int perMatMax = available / unitQty;
                if (perMatMax < maxProducible) maxProducible = perMatMax;
            }
            Map<String, Object> m = new HashMap<String, Object>();
            m.put("name",      mat.getName());
            m.put("code",      mat.getCode());
            m.put("unitQty",   unitQty);
            m.put("available", available);
            matList.add(m);
        }
        if (maxProducible < 0) maxProducible = 0;

        Map<String, Object> info = new HashMap<String, Object>();
        info.put("maxProducible", maxProducible);
        info.put("remaining",     remaining);
        info.put("materials",     matList);
        return info;
    }

    /** 활성 공정 = flow 순 첫 '완료' 아님 행. 전부 완료면 null */
    private Map<String, Object> findActiveProcess(int order_num) {
        for (Map<String, Object> wp : dao.getWorkProcesses(order_num)) {
            if (!"완료".equals(wp.get("STATUS"))) return wp;
        }
        return null;
    }

    private int maxFlow(int order_num) {
        int max = -1;
        for (Map<String, Object> wp : dao.getWorkProcesses(order_num)) {
            if (wp.get("FLOW") != null) max = Math.max(max, toInt(wp.get("FLOW")));
        }
        return max;
    }

    private Map<String, Object> statusMap(int order_num, int process_num, String status) {
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("order_num",   order_num);
        m.put("process_num", process_num);
        m.put("status",      status);
        return m;
    }

    private void setStatus(String work_order_id, String status) {
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("work_order_id", work_order_id);
        m.put("status",        status);
        dao.setWorkStatus(m);
    }

    private WorkDTO requireWork(String work_order_id) {
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }
        WorkDTO work = dao.getSelectOne(work_order_id);
        if (work == null) throw new IllegalArgumentException("work order not found: " + work_order_id);
        return work;
    }

    private int toInt(Object o) {
        if (o == null) return 0;
        if (o instanceof Number) return ((Number) o).intValue();
        return Integer.parseInt(o.toString());
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
