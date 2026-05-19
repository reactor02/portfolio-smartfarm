package kr.or.smartfarm.board;

import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardDTO {

	// Board Table ì»¬ëŸ¼  
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
	
	
	// ?˜?´ì§??„¤?´?…˜
	private int size = 10; 
	private int page = 1; 
	private int start = 0; 
	private int end; 
	
	
	// ê²??ƒ‰/ì¡°íšŒ?š©
	private String type; 
	private String keyword; 
	
	// selectbox  ?—¬?Ÿ¬ ê°? ê²??ƒ‰?š©
	private List boards;
	
}
