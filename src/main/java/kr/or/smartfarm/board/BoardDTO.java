package kr.or.smartfarm.board;

import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardDTO {

	// Board Table 컬럼  
	private int board_num;
	private String category;
	private String title; 
	private String content; 
	private int view_cnt; 
	private Date created_at; 
	private Date updated_at;
	private String board_status;
	private int flies_num; 
	private int emp_num;
	
	// board 페이지 용 emp 테이블 
	private String ename;
	
	
	// 검색조회
	private String type; 
	private String keyword; 
	
	// select 여러개용
	private List boards;
	

	
}
