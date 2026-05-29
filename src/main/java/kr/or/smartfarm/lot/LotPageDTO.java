package kr.or.smartfarm.lot;

import lombok.Data;

/**
 * LOT 목록 페이징 + 검색 필터 DTO.
 *
 * <p>page/size로 Oracle ROWNUM 범위(startRow~endRow)를 계산하고,
 * 날짜·상태·품목·키워드 필터를 함께 담아 lot.xml의 동적 쿼리에 전달한다.
 * 조회 후 totalCount/totalPages/startPage/endPage가 채워져 JSP 페이지네이션에 쓰인다.</p>
 */
@Data
public class LotPageDTO {
    private int page      = 1;   // 현재 페이지
    private int size      = 5;   // 페이지당 건수
    private int blockSize = 10;  // 페이지 블록 크기(하단 페이지 번호 묶음)

    private int totalCount;
    private int totalPages;
    private int startRow;
    private int endRow;
    private int startPage;
    private int endPage;

    // 필터
    private String startDate  = "";
    private String endDate    = "";
    private String lot_status = "";
    private String item_type  = "";
    private int    item_num;
    private String keyword    = "";
}
