package kr.or.smartfarm.prod;

import lombok.Data;

/**
 * 생산계획 목록 페이징 + 검색 필터 DTO.
 *
 * <p>page/size로 ROWNUM 범위를 계산하고, 날짜·상태·시설·품목·키워드 필터를
 * prod.xml 동적 쿼리에 전달한다. 조회 후 페이징 표시 값이 채워진다.</p>
 */
@Data
public class ProdPageDTO {
	private int page = 1;   // 현재 페이지
    private int size = 5;   // 페이지당 건수

    private int totalCount;
    private int totalPages;
    private int startRow;
    private int endRow;
    private int startPage;
    private int endPage;
    private int blockSize = 10;
    
    private String startDate = "";
    private String endDate = "";
    private String plan_status = "";
    private int facility_num;
    private int item_num;
    private String item_type = "";
    private String keyword = "";
}
