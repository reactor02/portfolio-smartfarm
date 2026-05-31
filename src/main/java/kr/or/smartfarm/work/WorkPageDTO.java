package kr.or.smartfarm.work;

import lombok.Data;

/**
 * 작업지시 목록 페이징 + 검색 필터 DTO.
 *
 * <p>page/size로 ROWNUM 범위(startRow~endRow)를 계산하고, 날짜·상태·품목·키워드
 * 필터를 work.xml 동적 쿼리에 전달한다. 조회 후 페이징 표시 값이 채워진다.</p>
 */
@Data
public class WorkPageDTO {
	private int page      = 1;   // 현재 페이지
	private int size      = 5;   // 페이지당 건수
	private int blockSize = 10;  // 페이지 블록 크기

	private int totalCount;
	private int totalPages;
	private int startRow;
	private int endRow;
	private int startPage;
	private int endPage;

	// 필터
	private String startDate   = "";
	private String endDate     = "";
	private String work_status = "";
	private String item_type   = "";
	private int    item_num    = 0;
	private String keyword     = "";
	private String sort        = "reg";  // 정렬: reg(최근 등록순), start(빠른 작업일순)
}
