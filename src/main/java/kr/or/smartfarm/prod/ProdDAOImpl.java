package kr.or.smartfarm.prod;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.work.WorkDTO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProdDAOImpl implements ProdDAO {

    @Autowired
    private SqlSession session;

    @Override
    public List<ProdDTO> getList(ProdPageDTO page) {
        return session.selectList("kr.or.smartfarm.prod.getList", page);
    }

    @Override
    public List<SelectOptionDTO> getEmpList() {
        return session.selectList("kr.or.smartfarm.prod.getEmpList");
    }

    @Override
    public List<SelectOptionDTO> getFacilityOptions() {
        return session.selectList("kr.or.smartfarm.prod.getFacilityOptions");
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.prod.getItemOptions");
    }

    @Override
    public ProdDTO getSelectOne(String plan_id) {
        return session.selectOne("kr.or.smartfarm.prod.getOne", plan_id);
    }

    @Override
    public int create(ProdDTO prodDTO) {
        return session.insert("kr.or.smartfarm.prod.insert", prodDTO);
    }

    @Override
    public int updateStatus(ProdDTO prodDTO) {
        return session.update("kr.or.smartfarm.prod.updateStatus", prodDTO);
    }

    @Override
    public List<WorkDTO> getWorkOrders(Map<String, Object> params) {
        return session.selectList("kr.or.smartfarm.prod.getWorkOrders", params);
    }
}
