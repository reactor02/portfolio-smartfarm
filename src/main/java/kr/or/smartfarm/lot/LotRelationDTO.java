package kr.or.smartfarm.lot;

import java.sql.Date;
import lombok.Data;

@Data
public class LotRelationDTO {
    private int    parent_lot_num;
    private int    child_lot_num;

    // JOIN 컬럼 (조회용)
    private String parent_lot_code;
    private String child_lot_code;
    private String item_name;
    private Date   lot_date;       // 소모일 (parent lot 생성일 기준)
    private String lot_status;
}
