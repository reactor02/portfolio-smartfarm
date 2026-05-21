package kr.or.smartfarm.prod;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.smartfarm.work.WorkDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProdServiceImpl implements ProdService {

    @Autowired
    private ProdDAO dao;

    @Override
    public List<ProdDTO> getList(ProdPageDTO page) {
        int startRow = (page.getPage() - 1) * page.getSize() + 1;
        int endRow   =  page.getPage()      * page.getSize();
        page.setStartRow(startRow);
        page.setEndRow(endRow);

        List<ProdDTO> list = dao.getList(page);

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
    public List<SelectOptionDTO> getEmpList() {
        return dao.getEmpList();
    }

    @Override
    public List<SelectOptionDTO> getFacilityOptions() {
        return dao.getFacilityOptions();
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return dao.getItemOptions();
    }

    @Override
    public ProdDTO selectOne(String plan_id) {
        return dao.getSelectOne(plan_id);
    }

    @Override
    public int create(ProdDTO prodDTO) {
        return dao.create(prodDTO);
    }

    @Override
    public void updateStatus(String plan_id, String status) {
        ProdDTO dto = new ProdDTO();
        dto.setPlan_id(plan_id);
        dto.setPlan_status(status);
        dao.updateStatus(dto);
    }

    @Override
    public Map<String, Object> getWorkOrders(int plan_num, int page) {
        int size     = 5;
        int startRow = (page - 1) * size + 1;
        int endRow   =  page      * size;

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("plan_num", plan_num);
        params.put("startRow", startRow);
        params.put("endRow",   endRow);

        List<WorkDTO> list = dao.getWorkOrders(params);

        int totalCount = (list != null && !list.isEmpty()) ? list.get(0).getTotal_count() : 0;
        int totalPages = totalCount > 0 ? (int) Math.ceil((double) totalCount / size) : 0;

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("list",        list);
        result.put("totalPages",  totalPages);
        result.put("totalCount",  totalCount);
        result.put("currentPage", page);
        return result;
    }
}
