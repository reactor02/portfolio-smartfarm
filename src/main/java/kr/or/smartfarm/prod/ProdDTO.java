package kr.or.smartfarm.prod;

import java.sql.Date;

import lombok.Data;

/**
 * 생산계획(production_plan) 데이터 전송 객체.
 *
 * <p>production_plan 컬럼 + 품목/사원/시설 JOIN 컬럼 +
 * 연관 작업지시 수량 합계(order_qty_sum)와 페이징용 total_count를 담는다.
 * (Lombok {@code @Data}로 getter/setter 자동 생성)</p>
 */
@Data
public class ProdDTO {
    private int    plan_num;
    private int    plan_qty;
    private String plan_status;
    private Date   plan_start;
    private Date   plan_end;
    private Date   created_at;
    private String content;
    private String plan_id;

    // 품목
    private int    item_num;
    private String code;
    private String type;
    private String item_name;

    // 사원
    private int    emp_num;
    private String ename;

    // 시설
    private int    facility_num;
    private String facility_name;

    // work_order SUM
    private int    currentqty;
    private int    order_qty_sum;   // 연관 작업지시 수량 합계

    private int    total_count;
}
