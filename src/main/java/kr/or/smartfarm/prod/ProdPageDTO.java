package kr.or.smartfarm.prod;

import lombok.Data;

@Data
public class ProdPageDTO {
	private int page = 1;
    private int size = 5;

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
