package kr.or.smartfarm.shipment;

import java.sql.Date;

import lombok.Data;

/**
 * 출하 데이터 전송 객체.
 *
 * <p>shipment 기본 컬럼 + 사원(emp)/출하요청(shipment_request)/품목(item)/거래처(vender)
 * JOIN 컬럼을 담는다. (Lombok {@code @Data}로 getter/setter 자동 생성)</p>
 */
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
