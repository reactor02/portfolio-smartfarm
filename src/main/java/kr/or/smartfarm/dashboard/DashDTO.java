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
}
