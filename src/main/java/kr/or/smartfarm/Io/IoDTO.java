package kr.or.smartfarm.Io;

import java.sql.Date;

import lombok.Data;
//	입/출고
@Data
public class IoDTO {
	
	private int ioNum; //시퀀스
	private int ioCount; //자재량
	private String ioType; //구분
	private Date ioDate;  //입출고 날짜
	
	
	private int qcNum;       //품질관리 시퀀스
	private int lotNum;      //Lot 시퀀스
	private int orderNum;    //작업지시 시퀀스
}
