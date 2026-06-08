package kr.or.smartfarm.lot;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
 * 공정 라우트 흐름도의 한 단계(공정 노드).
 *
 * <p>품목의 공정(process) 1건을 흐름도 노드로 표현하며, 그 공정에서 투입되는
 * 자재 목록({@link LotRouteMaterialDTO})을 함께 담는다. JSP는 이 목록을 flow 순서대로
 * 가로 노드로 그리고, 각 노드 위에 materials 를 자재 칩으로 합류시킨다.</p>
 *
 * <p>process_num == 0 / flow == null 인 가상 단계는 "공정 미지정"(bom.process_num IS NULL)
 * 자재 묶음을 표현한다.</p>
 */
@Data
public class LotRouteStepDTO {
    /** 공정 PK (가상 "공정 미지정" 단계는 0) */
    private int     process_num;
    /** 공정 순서 (flow). 미지정 단계는 null */
    private Integer flow;
    /** 공정 내용/설명 */
    private String  process_content;
    /** 작업 인원 */
    private int     head_count;
    /** 작업 설비명 (없으면 null) */
    private String  facility_name;
    /** 이 공정에 투입되는 자재 칩 목록 */
    private List<LotRouteMaterialDTO> materials = new ArrayList<>();
}
