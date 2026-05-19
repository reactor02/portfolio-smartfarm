package kr.or.smartfarm.prod;

import lombok.Data;

@Data
public class ProdPageDTO {
	private int page = 1;
    private int size = 10;

    private int totalCount;
    private int totalPages;
    private int startRow;
    private int endRow;
    private int startPage;
    private int endPage;
    private int blockSize = 10;
    
    private String keyword = "";
  	private String searchType = "";
}
