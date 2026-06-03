package kr.or.smartfarm.lot;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * LOT 관계(lot_relation) DAO 구현체.
 *
 * <p>lot_relation 테이블(lot_parent → lot_child)을 통해 롯이력을 추적한다.
 * 이 관계는 두 가지 의미로 쓰인다:</p>
 * <ul>
 *   <li>생산: parent=생산결과 LOT, child=소모된 자재 LOT</li>
 *   <li>출하 분할: parent=원본 LOT, child=분할 생성된 자식 LOT</li>
 * </ul>
 * <p>재귀 조회(getRecursiveMaterials/getLotHistory)는 Oracle CONNECT BY로
 * 다단계 이력을 탐색하며, lot.xml에 NOCYCLE 가드가 적용되어 있다.</p>
 */
@Repository
public class LotRelationDAOImpl implements LotRelationDAO {

    /** MyBatis SQL 실행 세션 */
    @Autowired
    private SqlSession session;

    /** lot_relation 1건 등록 (부모-자식 연결) */
    @Override
    public void insert(LotRelationDTO dto) {
        session.insert("kr.or.smartfarm.lot.insertLotRelation", dto);
    }

    /** 이 생산 LOT(parent)에 직접 투입된 소모 자재 LOT 목록 (1단계) */
    @Override
    public List<LotRelationDTO> getMaterialsByChildLot(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getMaterialsByChildLot", lot_num);
    }

    /** 이 LOT(child)이 자재로 투입된 상위 생산 LOT 목록 */
    @Override
    public List<LotRelationDTO> getParentsByLot(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getParentsByLot", lot_num);
    }

    /** CONNECT BY 재귀로 모든 단계의 소모 자재 트리 조회 */
    @Override
    public List<Map<String, Object>> getRecursiveMaterials(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getRecursiveMaterials", lot_num);
    }

    /** 분할 자식 LOT의 원본 LOT 번호 조회 (lot_split 테이블, 분할이 아니면 null) */
    @Override
    public Integer getOriginLotNum(int lot_num) {
        return session.selectOne("kr.or.smartfarm.lot.getOriginLotNum", lot_num);
    }

    /** 롯이력 통합 조회 (입고/생산/출하 등 전 이력, UNION ALL + CONNECT BY) — map 키: prodLot, selfLot */
    @Override
    public List<Map<String, Object>> getLotHistory(java.util.Map<String,Object> param) {
        return session.selectList("kr.or.smartfarm.lot.getLotHistory", param);
    }
}
