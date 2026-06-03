package kr.or.smartfarm.defective;

import java.sql.Date;

import lombok.Data;

//재고
@Data
public class DefectiveDTO {
	
	//equipment_log
	private int defect_num;
	private String defect_reason;
	private String defect_action;
	private String defect_status;
	
	// qc
	private int qc_num;
	private String qc_type;
	
	// item
	private int item_num;
	private String code;
	private String name;
	private String unit;
	
	// io
	private int io_num;
	private int io_qty;
	private int defect_qty;
	private Date io_date;
	
	// lot_num
	private int lot_num;
	private String lot_code;
	
	// emp
	private int emp_num;
	private String ename;
	
	
}
