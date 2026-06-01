package kr.or.smartfarm.usermanage;

import java.sql.Date;

import lombok.Data;

@Data
public class TodayWorkDTO {
	
	 // 멤버 변수 (Fields)
    private int order_num;          // order_num (PK)
    private String order_id;        // 작업코드
    private Date order_date;        // 작업실시날짜 (생산관리계획 시작날짜~종료날짜)
    private int order_qty;          // 목표수량
    private String order_status;    // 작업상태 (진행, 대기, 취소, 완료)
    private int emp_num;            // 사원_시퀀스 (FK) - 작업자
    private int plan_num;           // 생산관리_시퀀스 (FK)
    private int current_qty;        // 현재수량
    private String content;         // 주의사항
    private Date created_at;        // 등록일
    private Date work_start;        // 작업시작날짜
    private Date work_end;          // 작업종료날짜
    private int scrap_qty;          // 폐기수량

}
