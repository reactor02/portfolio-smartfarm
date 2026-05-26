package kr.or.smartfarm.lot;

import java.sql.Date;
import lombok.Data;

@Data
public class LotDTO {
    // lot 테이블
    private int    lot_num;
    private String lot_code;      // LOT번호
    private Date   expiry_date;   // 만료일
    private int    item_num;
    private int    order_num;     // 작업지시 FK
    private Date   lot_date;      // 생성일
    private int    init_qty;      // 초기수량
    private int    current_qty;   // 현재수량
    private String lot_status;    // 상태

    // JOIN 컬럼
    private String item_name;
    private String code;
    private String type;

    // 페이징
    private int total_count;
}
