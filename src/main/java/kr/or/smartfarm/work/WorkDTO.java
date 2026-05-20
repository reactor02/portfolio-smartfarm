package kr.or.smartfarm.work;

import java.sql.Date;

import lombok.Data;

@Data
public class WorkDTO {
	// work_order
	private int order_num;
	private int order_qty;
	private String order_status;
	private int emp_num;
	private int plan_num;
	private int current_qty;
	private String content;
	private Date created_at;
	private Date order_start;
	private Date order_end;
	private int scrap_qty;
	private String order_id;
	
	
}
