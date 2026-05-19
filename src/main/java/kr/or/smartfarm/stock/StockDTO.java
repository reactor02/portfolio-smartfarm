package kr.or.smartfarm.stock;

import lombok.Data;

//재고
@Data
public class StockDTO {
	
	private int strockId;	//시퀀스
	private int count; //개수
	

	private int itemNum; // item시퀀스

}
