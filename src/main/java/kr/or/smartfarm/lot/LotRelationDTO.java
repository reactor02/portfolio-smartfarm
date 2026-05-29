package kr.or.smartfarm.lot;

import java.sql.Date;
import lombok.Data;

/**
 * LOT 관계(lot_relation) 데이터 전송 객체.
 *
 * <p>부모 LOT(parent)과 자식 LOT(child)의 연결을 표현한다.
 * 생산에서는 parent=생산결과, child=소모자재이고,
 * 출하 분할에서는 parent=원본, child=분할 자식 LOT이다.
 * (Lombok {@code @Data}로 getter/setter 자동 생성)</p>
 */
@Data
public class LotRelationDTO {
    /** 부모 LOT 내부 PK */
    private int    parent_lot_num;
    /** 자식 LOT 내부 PK */
    private int    child_lot_num;

    // JOIN 컬럼 (조회용)
    private String parent_lot_code;
    private String child_lot_code;
    private String item_name;
    private Date   lot_date;       // 소모일 (parent lot 생성일 기준)
    private String lot_status;
    private int    required_qty;   // BOM.required_qty × 생산LOT.init_qty (소모 계획 수량)
}
