package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LotDAOImpl implements LotDAO {

    @Autowired
    private SqlSession session;

    @Override
    public List<LotDTO> getList(LotPageDTO page) {
        return session.selectList("kr.or.smartfarm.lot.getList", page);
    }

    @Override
    public LotDTO getSelectOne(String lot_code) {
        return session.selectOne("kr.or.smartfarm.lot.getOne", lot_code);
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.lot.getItemOptions");
    }
}
