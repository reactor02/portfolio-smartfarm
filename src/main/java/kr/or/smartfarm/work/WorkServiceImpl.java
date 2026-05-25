package kr.or.smartfarm.work;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class WorkServiceImpl implements WorkService {

    @Autowired
    private WorkDAO dao;

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
        WorkDTO dto = new WorkDTO();
        dto.setWork_order_id(work_order_id);
        dao.produce(dto);
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
}
