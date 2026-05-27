package kr.or.smartfarm.equipment_log;

import java.sql.Date;

import lombok.Data;

//재고
@Data
public class EquipDTO {
	
	//equipment_log
	private int equip_num;
	private String equip_status;
	private String error_sign;
	private String equip_action;
	private Date maintenance_date;
	private Date start_date;
	private Date end_date;
	
	// item
	private int item_num;
	private String code;
	private String name;
	
	// emp
	private int emp_num;
	private String ename;
	
}
