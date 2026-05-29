package kr.or.smartfarm.lot;

import java.sql.Date;
import lombok.Data;

/**
 * LOT 데이터 전송 객체.
 *
 * <p>lot 테이블 컬럼 + 화면 표시용 JOIN 컬럼 + QC/페이징 보조 컬럼을 함께 담는다.
 * (Lombok {@code @Data}로 getter/setter 자동 생성)</p>
 */
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
    

    // JOIN 컬럼
    private String item_name;
    private String code;
    private String type;

    // QC PASS 조회 시 매핑용
    private int qc_num;

    // 페이징
    private int total_count;
}
