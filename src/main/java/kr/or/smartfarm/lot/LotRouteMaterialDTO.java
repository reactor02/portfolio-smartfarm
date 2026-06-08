package kr.or.smartfarm.lot;

import lombok.Data;

/**
 * 공정 라우트 흐름도에서 한 공정 노드에 합류하는 투입 자재 1건.
 *
 * <p>bom 테이블의 자재 라인(item_num2)을 공정 노드 위 "자재 칩"으로 표시하기 위한 DTO.
 * (Lombok {@code @Data}로 getter/setter 자동 생성)</p>
 */
@Data
public class LotRouteMaterialDTO {
    /** 투입 자재 품목 PK (bom.item_num2) */
    private int    material_num;
    /** 투입 자재 품목명 */
    private String material_name;
    /** 단위 소요량 (bom.required_qty) */
    private int    required_qty;
}
