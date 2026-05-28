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
        // [1] 작업지시 상세 조회 (item_num, type, order_qty, order_num, plan_num 포함)
        WorkDTO work = dao.getSelectOne(work_order_id);
        int itemNum  = work.getItem_num();
        int orderQty = work.getOrder_qty();
        int orderNum = work.getOrder_num();
        int planNum  = work.getPlan_num();
        String type  = work.getType();

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
    public List<SelectOptionDTO> getPlanOptions() {
        return dao.getPlanOptions();
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return dao.getItemOptions();
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
}
