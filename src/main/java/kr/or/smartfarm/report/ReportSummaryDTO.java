package kr.or.smartfarm.report;

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
}
