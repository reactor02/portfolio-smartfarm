package kr.or.smartfarm.bom;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import lombok.Data;
//Bom
@Data
public class BomDTO {

	private int bom_num; //시퀀스
	private int required_qty; //요구량(기준생산수량)
	private int child_qty;    //기준생산수량 대비 투입 소모자재 수량
	private String bom_status; //사용여부(Y / N)
	private String bom_code;//봄코드
	private Date created_at;//등록일자


	private int item_num; // item부모 시퀀스
	private int item_num2;// item자식 시퀀스
	private String name;//item name
	private String code;//item code
	private String type;// item type
	
	
	private String parent_item_num;
    private int parent_qty;
    private List<Map<String, Object>>  childList;
    private int qty;
    
    
    private int count;
    private double temp;
    private double humid;
}
