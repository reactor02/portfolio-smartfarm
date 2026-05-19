package kr.or.smartfarm.process;

import lombok.Data;

//공정
@Data
public class ProcessDTO {
	
	private int processNum; //시퀀스
	private String content; //공정 방법
	private int flow; //공정 순서
	private String url; //공정 이미지 url
	

	private int itemNum; //item시퀀스
}
