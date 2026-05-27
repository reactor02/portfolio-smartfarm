package kr.or.smartfarm.io;

import java.sql.Date;

import lombok.Data;
//	입/출고
@Data
public class IoDTO {
	
	private int io_num; //시퀀스
	private String io_type; //구분
	private Date io_date;  //입출고 날짜
	private String type;
	private String keyword;
	

}
