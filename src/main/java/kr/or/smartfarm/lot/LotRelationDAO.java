package kr.or.smartfarm.lot;

import java.util.List;
import java.util.Map;

/**
 * LOT 관계(lot_relation) 데이터 접근 인터페이스.
 * 부모-자식 LOT 연결을 통한 롯이력 추적 쿼리를 정의한다.
 * 구현은 {@link LotRelationDAOImpl}.
 */
public interface LotRelationDAO {
    /** lot_relation 1건 등록 (부모-자식 연결) */
    void                         insert(LotRelationDTO dto);
    /** 생산 LOT에 투입된 소모 자재 LOT 목록 (1단계) */
    List<LotRelationDTO>         getMaterialsByChildLot(int lot_num);
    /** 이 LOT이 자재로 투입된 상위 생산 LOT 목록 */
    List<LotRelationDTO>         getParentsByLot(int lot_num);
    /** CONNECT BY 재귀로 다단계 소모 자재 트리 조회 */
    List<Map<String, Object>>    getRecursiveMaterials(int lot_num);
    /** 분할 자식 LOT의 원본 LOT 번호 조회 (분할이 아니면 null) */
    Integer                      getOriginLotNum(int lot_num);
    /** 롯이력 통합 조회 (전 이력) — map 키: prodLot, selfLot */
    List<Map<String, Object>>    getLotHistory(java.util.Map<String,Object> param);
}
