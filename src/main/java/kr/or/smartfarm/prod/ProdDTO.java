package kr.or.smartfarm.prod;

import java.sql.Date;

import lombok.Data;

@Data
public class ProdDTO {
	 private int plan_num;
	    private int plan_qty;
	    private String plan_status;
	    private Date plan_start;
	    private Date plan_end;

	   
	   
//	    품목이름
	    private int item_num;
	    private String item_name;
	    
//	    사원이름
	    private int emp_num;
	    private String ename;
	    
//	    시설 모음
	    private int facility_num;
	    private String facility_name;
	
	    // work_order sum�� ����
	    private int currentqty;
	    
	    private int total_count; 
}
