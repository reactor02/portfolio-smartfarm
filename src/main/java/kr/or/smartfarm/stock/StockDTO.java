package kr.or.smartfarm.stock;

import lombok.Data;

//재고
@Data
public class StockDTO {
	
	private int strock_id;	//시퀀스
	private int stock_qty; //개수
	

	private int item_num; // item시퀀스
	private String code;
	private String name;
	private String type;
	private String unit;

}
