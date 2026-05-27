package kr.or.smartfarm.request;

import java.sql.Date;

import lombok.Data;

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
