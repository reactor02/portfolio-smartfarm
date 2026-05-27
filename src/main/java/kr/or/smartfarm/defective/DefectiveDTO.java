package kr.or.smartfarm.defective;

import java.sql.Date;

import lombok.Data;

//재고
@Data
public class DefectiveDTO {
	
	//equipment_log
	private int defective_num;
	private String defect_reason;
	private String defect_action;
	private String defect_status;
	
	// item
	private int item_num;
	private String code;
	private String name;
	
	// io
	private int io_num;
	private int io_qty;
	private Date io_date;
	
}
