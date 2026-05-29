package kr.or.smartfarm.report;

import java.sql.Date;

import lombok.Data;

@Data
public class ReportSummaryDTO {

	// stock 페이지 
	private String code; 
	private String name;
	private int stock_qty; 
	
	// bom 페이지 
	private String bom_code; 
	private String bom_status; 
	
	// equip 페이지 
	private String equip_status; 
	
	// lot 페이지 
	private String lot_code;  
	private Date lot_date;
	
	// qc 페이지 
	private String qc_type; 
	private String qc_pass;
	private Date io_date; 
	
	// io 페이지 
	private String io_type; 
	private String facility_name;
	
	// process 페이지 
	private String type; 
	private String process_status;
	
}
