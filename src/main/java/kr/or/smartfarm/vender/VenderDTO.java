package kr.or.smartfarm.vender;

import lombok.Data;

@Data
public class VenderDTO {

	private int vender_num;
	private String vender_name; 
	private int emp_num;
	private String vender_type;
	private String vender_phone;
	private String vender_addr;
	private String ven_ename;
	private String biz_no;
	
	// emp 테이블 조인용
	private String ename;
	
}
