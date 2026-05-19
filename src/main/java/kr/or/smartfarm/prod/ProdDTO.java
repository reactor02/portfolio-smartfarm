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
	    private int emp_num;
	    private int item_num;
	    private String ename;
	    
	    
	    private int facility_num;
	    private String facility_name;
	
	    // work_order sum�� ����
	    private int currentqty;
	    
	    private int totalCount; 
}
