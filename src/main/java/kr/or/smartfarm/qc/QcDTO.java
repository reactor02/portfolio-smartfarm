package kr.or.smartfarm.qc;

import java.sql.Date;

import lombok.Data;

//재고
@Data
public class QcDTO {
	
	// qc
	private int qc_num;
	private String qc_type;
	private String qc_pass;
	
	// item
	private int item_num;
	private String code;
	private String name;
	private String unit;
	
	// io
	private Integer io_num;
	private int io_qty;
	private Date io_date;
	
	// emp
	private int emp_num;
	private String ename;
	
	// lot 
	private int lot_num;
	private String lot_code;
	
	// defective
	private int defect_qty;
	
	private int total_qty;

}
