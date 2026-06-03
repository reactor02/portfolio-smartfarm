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
    public void produce(String work_order_id) {
        // [0][방어] 식별자 누락 차단 — work_order_id가 비어 있으면 조회 자체가 무의미
        if (work_order_id == null || work_order_id.trim().isEmpty()) {
            throw new IllegalArgumentException("work_order_id is required");
        }

        // [1] 작업지시 상세 조회 (item_num, type, order_qty, order_num, plan_num 포함)
        WorkDTO work = dao.getSelectOne(work_order_id);
        // [방어] 존재하지 않는/이미 삭제된 작업지시면 work가 null → 이후 getter에서 NPE.
        //        잘못된 호출이므로 명확히 예외로 끊어 생산 처리를 진행하지 않는다.
        if (work == null) {
            throw new IllegalArgumentException("work order not found: " + work_order_id);
        }

        int itemNum  = work.getItem_num();
        int orderQty = work.getOrder_qty();
        int orderNum = work.getOrder_num();
        int planNum  = work.getPlan_num();
        String type  = work.getType();

        // [방어] 생산 수량이 0 이하면 LOT 생성·자재 차감이 무의미하거나 음수 차감을 유발.
        //        데이터 무결성을 위해 진행 전에 차단한다.
        if (orderQty <= 0) {
            throw new IllegalArgumentException("order_qty must be positive: " + orderQty);
        }

        // [2] BOM 재료 목록 조회
        List<BomDTO> materials = dao.getMaterialsByItem(itemNum);

        // [3] 재고 사전 검증 — 부족하면 즉시 예외
        for (BomDTO mat : materials) {
            int totalNeeded = mat.getRequired_qty() * orderQty;
            List<LotDTO> lots = lotDao.getQcPassedLotsFIFO(mat.getItem_num2());
            int available = 0;
            for (LotDTO l : lots) available += l.getCurrent_qty();
            if (available < totalNeeded) {
                throw new RuntimeException("stock_error");
            }
        }

        // [4] 새 LOT 생성 (selectKey로 lot_num 채번, lot_code 자동 조합)
        LotDTO newLot = new LotDTO();
        newLot.setItem_num(itemNum);
        newLot.setOrder_num(orderNum);
        newLot.setInit_qty(orderQty);
        newLot.setCurrent_qty(orderQty);
        newLot.setType(type);
        lotDao.insertLot(newLot);
        int newLotNum = newLot.getLot_num();

        // [4-1] 생산 결과 LOT 입고 처리 (생산입고) — LOT 생성 직후 바로 입고 기록
        //       io_type='입고', io_reason='생산입고', 해당 품목 type의 검사대기 QC 자동 연결,
        //       보관 설비 facility_num=3, 담당자 emp_num=작업지시 실무자, qc_chked='N'
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("ioQty",    orderQty);
        inMap.put("lotNum",   newLotNum);
        inMap.put("itemType", type);
        inMap.put("empNum",   work.getWorker_num());
        dao.insertProduceIo(inMap);

        // [4-2] 생산된 품목 stock 증가 (stock 행이 있을 때만 반영, 신규 행 생성 안 함)
        Map<String, Object> stockInMap = new HashMap<String, Object>();
        stockInMap.put("itemNum", itemNum);
        stockInMap.put("qty",     orderQty);
        dao.adjustStock(stockInMap);

        // [5] 재료별 FIFO 차감 + io 출고 기록 + lot_relation 기록
        for (BomDTO mat : materials) {
            int totalNeeded = mat.getRequired_qty() * orderQty;
            List<LotDTO> lots = lotDao.getQcPassedLotsFIFO(mat.getItem_num2());

            for (LotDTO lot : lots) {
                if (totalNeeded <= 0) break;
                int deduct = Math.min(lot.getCurrent_qty(), totalNeeded);

                // ① lot 수량 차감
                lotDao.deductQty(lot.getLot_num(), deduct);

                // ② io 출고 기록
                Map<String, Object> ioMap = new HashMap<String, Object>();
                ioMap.put("ioType",   "출고");
                ioMap.put("ioQty",    deduct);
                ioMap.put("qcNum",    lot.getQc_num());
                ioMap.put("lotNum",   lot.getLot_num());
                ioMap.put("planNum",  planNum);   // io.plan_num NOT NULL (삭제예정)
                ioMap.put("ioReason", "생산투입");
                dao.insertIo(ioMap);

                // ③ lot_relation 기록 (lot_parent = 생산결과, lot_child = 소모재료)
                LotRelationDTO rel = new LotRelationDTO();
                rel.setParent_lot_num(newLotNum);       // 생산결과 LOT = parent
                rel.setChild_lot_num(lot.getLot_num()); // 소모재료 LOT = child
                lotRelationDao.insert(rel);

                totalNeeded -= deduct;
            }

            // 자재 stock 차감 (stock 행이 있을 때만 반영, 신규 행 생성 안 함)
            // 내부 루프에서 totalNeeded가 0이 되므로 총 소모량은 다시 계산
            Map<String, Object> stockOutMap = new HashMap<String, Object>();
            stockOutMap.put("itemNum", mat.getItem_num2());
            stockOutMap.put("qty",     -(mat.getRequired_qty() * orderQty));
            dao.adjustStock(stockOutMap);
        }

        // [6] work_order 완료 처리
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dao.produce(dto);
        dao.completePlanIfDone(work_order_id);
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
}
