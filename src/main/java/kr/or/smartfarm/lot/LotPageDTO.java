package kr.or.smartfarm.lot;

import lombok.Data;

@Data
public class LotPageDTO {
    private int page      = 1;
    private int size      = 10;
    private int blockSize = 10;

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
    private int    item_num;
    private String keyword    = "";
}
