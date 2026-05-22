package kr.or.smartfarm.work;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class WorkDTO {
	// work_order 테이블 컬럼
	private int    order_num;
	private String work_order_id;  // DB: order_id → SQL alias
	private int    plan_num;
	private int    order_qty;
	private String work_status;    // DB: order_status → SQL alias
	private int    emp_num;
	private int    current_qty;
	private String content;
	private Date   created_at;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date   order_start;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date   order_end;

	// JOIN 컬럼
	private String ename;          // emp
	private String item_name;      // item (production_plan 경유)
	private String code;
	private String type;
	private int    item_num;       // item (공정 링크용)
	private int    plan_qty;       // production_plan
	private String plan_id;        // production_plan
	private int    facility_num;   // process 경유
	private String facility_name;

	// 페이징
	private int total_count;
}
