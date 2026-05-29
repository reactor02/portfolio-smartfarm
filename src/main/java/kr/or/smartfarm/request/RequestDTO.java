package kr.or.smartfarm.request;

import java.sql.Date;

import lombok.Data;

/**
 * 출하요청(주문) 데이터 전송 객체.
 *
 * <p>요청 기본 컬럼 + 거래처(Vendor)/사원(emp)/품목(Item) JOIN 컬럼을 담는다.
 * (Lombok {@code @Data}로 getter/setter 자동 생성)</p>
 */
@Data
public class RequestDTO {
    private String request_id;
    private Date request_date;
    private int vender_num;
    private Date due_date;
    private String request_status;
    private int item_num;

    // Vendor 정보
    private String vender_name;
    private String vender_type;
    private int emp_num;
    
    // emp
    private String ename;

    // Item 정보
    private String name;
    private String type;
}
