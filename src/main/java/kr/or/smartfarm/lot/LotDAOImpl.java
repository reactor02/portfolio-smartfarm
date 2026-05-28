package kr.or.smartfarm.lot;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    	List<LotDTO> a = session.selectList("kr.or.smartfarm.lot.getList", page);
    	System.out.println("겟롯"+a.get(0).getLot_code());
        return a;
    }

    @Override
    public LotDTO getSelectOne(String lot_code) {
        return session.selectOne("kr.or.smartfarm.lot.getOne", lot_code);
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.lot.getItemOptions");
    }

    @Override
    public void insertLot(LotDTO dto) {
        session.insert("kr.or.smartfarm.lot.insertLot", dto);
    }

    @Override
    public void deductQty(int lot_num, int deduct_qty) {
        Map<String, Integer> param = new HashMap<String, Integer>();
        param.put("lot_num",    lot_num);
        param.put("deduct_qty", deduct_qty);
        session.update("kr.or.smartfarm.lot.deductQty", param);
    }

    @Override
    public List<LotDTO> getQcPassedLotsFIFO(int item_num) {
        return session.selectList("kr.or.smartfarm.lot.getQcPassedLotsFIFO", item_num);
    }
}
