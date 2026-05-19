package kr.or.smartfarm.bom;

import lombok.Data;
//Bom
@Data
public class BomDTO {

	private int bomNum; //시퀀스
	private int demand; //요구량
	private int using; //사용여부(Y / N)
	

	private int itemNum; // item시퀀스

}
