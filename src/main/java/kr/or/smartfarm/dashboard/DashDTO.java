package kr.or.smartfarm.dashboard;

import java.sql.Date;

import lombok.Data;

@Data
public class DashDTO {

	// 게시판 공지사항
	private int board_num;
	private String category; 
	private String title; 
	private int emp_num; 
	private Date created_at; 
	
	// 게시판에서 사원 번호로 이름 보여주기 
	private String ename;
	
	// 생산, 출하 그래프 
	private int plan_qty;
	private int ship_qty; 
	private Date plan_start; 
	private Date shipment_date; 
	private String plan_id;
	private String plan_status;
	private String shipment_status;
	private String dt;
	
	// 불량 개수 
	private int defect_qty;
	private Date io_date;
	
	// 아이템 
	private String name;
	private String unit;

	// 작업지시
	private String order_id;
	private String order_status;
	private Integer order_qty;
	private Integer current_qty;
	
	
	
	
}

