package kr.or.smartfarm.qc;

import java.sql.Date;

import lombok.Data;

//재고
@Data
public class QcDTO {
	
	// qc
	private String qc_type;
	private String qc_pass;
	
	
	// item
	private String code;
	private String name;
	private String unit;
	
	// io
	private int io_num;
	private int io_qty;
	private Date io_date;

}
