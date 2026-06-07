package kr.or.smartfarm.work;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

/**
 * 작업지시(work_order) 데이터 전송 객체.
 *
 * <p>work_order 테이블 컬럼 + emp/item/production_plan/process JOIN 컬럼 +
 * 페이징용 total_count를 함께 담는다. order_id/order_status는 SQL에서
 * work_order_id/work_status 별칭으로 매핑된다.
 * 날짜 필드는 {@code @JsonFormat}으로 JSON 직렬화 시 yyyy-MM-dd로 표기된다.</p>
 */
@Data
public class WorkDTO {
	// work_order 테이블 컬럼
	private int    order_num;
	private String work_order_id;  // DB: order_id → SQL alias
	private int    plan_num;
	private int    order_qty;
	private String work_status;    // DB: order_status → SQL alias
	private int    emp_num;
	private int    current_qty;
	private int    input_qty;      // 배치 생산수량(공정별 흐름에서 1회 확정)
	private Integer product_lot_num; // 작업시작 시 생성한 완제품 LOT
	private String content;
	private java.sql.Timestamp created_at;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date   order_start;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date   order_end;

	// work_order 실무자 컬럼
	private int    worker_num;

	// JOIN 컬럼
	private String ename;          // emp (담당자)
	private String worker_ename;   // emp (실무자)
	private String item_name;      // item (production_plan 경유)
	private String code;
	private String type;
	private int    item_num;       // item (공정 링크용)
	private int    plan_qty;       // production_plan
	private String plan_id;        // production_plan
	private String plan_status;    // production_plan
	private Date   plan_start;     // production_plan
	private Date   plan_end;       // production_plan
	private int    facility_num;   // process 경유
	private String facility_name;

	// 페이징
	private int total_count;
}
