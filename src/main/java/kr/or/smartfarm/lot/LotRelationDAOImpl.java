package kr.or.smartfarm.lot;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LotRelationDAOImpl implements LotRelationDAO {

    @Autowired
    private SqlSession session;

    @Override
    public void insert(LotRelationDTO dto) {
        session.insert("kr.or.smartfarm.lot.insertLotRelation", dto);
    }

    @Override
    public List<LotRelationDTO> getMaterialsByChildLot(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getMaterialsByChildLot", lot_num);
    }

    @Override
    public List<LotRelationDTO> getParentsByLot(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getParentsByLot", lot_num);
    }

    @Override
    public List<Map<String, Object>> getRecursiveMaterials(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getRecursiveMaterials", lot_num);
    }

    @Override
    public List<Map<String, Object>> getLotHistory(int lot_num) {
        return session.selectList("kr.or.smartfarm.lot.getLotHistory", lot_num);
    }
}
