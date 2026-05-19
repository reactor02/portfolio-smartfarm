package kr.or.smartfarm.prod;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProdServiceImpl implements ProdService {
	
	@Autowired
	private ProdDAO dao;
	
	@Override
    public List<ProdDTO> getList(ProdPageDTO page) {
        // startRow, endRow 먼저 계산
        int startRow = (page.getPage() - 1) * page.getSize() + 1;
        int endRow = page.getPage() * page.getSize();
        page.setStartRow(startRow);
        page.setEndRow(endRow);

        List<ProdDTO> list = dao.getList(page);

        // 첫 번째 행에서 전체 건수 꺼내서 PageDTO로 이동
        if (list != null && !list.isEmpty()) {
            int totalCount = list.get(0).getTotal_count();
            page.setTotalCount(totalCount);

            // 전체 페이지 수 계산
            int totalPages = (int) Math.ceil((double) totalCount / page.getSize());

            // 현재 블록 시작 페이지 번호
            int startPage = (((page.getPage() - 1) / page.getBlockSize()) * page.getBlockSize()) + 1;

            // 현재 블록 끝 페이지 번호 (전체 페이지 수 초과 방지)
            int endPage = Math.min(startPage + page.getBlockSize() - 1, totalPages);

            page.setTotalPages(totalPages);
            page.setStartPage(startPage);
            page.setEndPage(endPage);
        }

        return list;
    }
	
	public List<SelectOptionDTO> getFacilityOptions() {
	    return dao.getFacilityOptions();
	}

	public List<SelectOptionDTO> getItemOptions() {
	    return dao.getItemOptions();
	}
}
