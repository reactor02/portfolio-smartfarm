package kr.or.smartfarm.shipment;

import java.sql.Date;

import lombok.Data;

@Data
public class ShipmentDTO {
	  private String shipment_num;
	    private String shipment_id;
	    private int emp_num;
	    private Date shipment_date;
	    private String shipment_status;
	    private int plan_qty;
	    private int shipment_request_num;

	    // emp 테이블
	    private String ename;

	    // shipment_request 테이블
	    private int vender_seq;
	    private String item_num;

	    // item 테이블
	    private String name;

	    // vender 테이블
	    private String vender_name;
	
}
