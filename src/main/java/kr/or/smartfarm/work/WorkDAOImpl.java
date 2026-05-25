package kr.or.smartfarm.work;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class WorkDAOImpl implements WorkDAO {

    @Autowired
    private SqlSession session;

    @Override
    public List<WorkDTO> getList(WorkPageDTO page) {
        return session.selectList("kr.or.smartfarm.work.getList", page);
    }

    @Override
    public WorkDTO getSelectOne(String work_order_id) {
        return session.selectOne("kr.or.smartfarm.work.getOne", work_order_id);
    }

    @Override
    public int create(WorkDTO workDTO) {
        return session.insert("kr.or.smartfarm.work.insert", workDTO);
    }

    @Override
    public int updateStatus(WorkDTO workDTO) {
        return session.update("kr.or.smartfarm.work.updateStatus", workDTO);
    }

    @Override
    public int produce(WorkDTO workDTO) {
        return session.update("kr.or.smartfarm.work.produce", workDTO);
    }

    @Override
    public List<SelectOptionDTO> getEmpOptions() {
        return session.selectList("kr.or.smartfarm.work.getEmpOptions");
    }

    @Override
    public List<SelectOptionDTO> getPlanOptions() {
        return session.selectList("kr.or.smartfarm.work.getPlanOptions");
    }

    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.work.getItemOptions");
    }
}
