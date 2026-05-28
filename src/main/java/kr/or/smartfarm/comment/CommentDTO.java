package kr.or.smartfarm.comment;

import java.sql.Date;

import lombok.Data;

@Data
public class CommentDTO {

	private int comment_num; 
	private String parent_cmt; 
	private String cmt_content;
	private Date writed_at; 
	private String comment_status; 
	private int board_num; 
	private int emp_num; 
	
	
	// emp 테이블 조회용
	private String ename; 
	
}
