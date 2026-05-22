package kr.or.smartfarm.bom;

import java.sql.Date;

import lombok.Data;
//Bom
@Data
public class BomDTO {

	private int bom_num; //시퀀스
	private int required_qty; //요구량(기준생산수량)
	private int bom_status; //사용여부(Y / N)
	private String bom_code;//봄코드
	private Date created_at;//등록일자


	private int item_num; // item부모 시퀀스
	private int item_num2;// item자식 시퀀스
	private String name;//item name
	private String code;//item code
	private String type;// item type
	
	
}
