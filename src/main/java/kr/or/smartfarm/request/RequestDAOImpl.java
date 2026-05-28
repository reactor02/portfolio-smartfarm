package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class RequestDAOImpl implements RequestDAO {

    @Autowired
    SqlSession sqlSession;

    @Override
    public List selectAll(int pageNum) {
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.request.loadRequest");
    }

    @Override
    public List searchRequest(Map map) {
        int pageNum = (Integer) map.get("page");
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.request.searchRequest", map);
    }

    @Override
    public List searchVender(String keyword) {
        return sqlSession.selectList("kr.or.smartfarm.request.searchVender", keyword);
    }

    @Override
    public List loadProducts() {
        return sqlSession.selectList("kr.or.smartfarm.request.loadProducts");
    }

    @Override
    public int insertRequest(Map map) {
        return sqlSession.insert("kr.or.smartfarm.request.insertRequest", map);
    }

    @Override
    public Map selectDetail(String requestId) {
        return sqlSession.selectOne("kr.or.smartfarm.request.loadRequestDetail", requestId);
    }

    @Override
    public int hasShipment(String shipmentRequestNum) {
        return sqlSession.selectOne("kr.or.smartfarm.request.hasShipment", shipmentRequestNum);
    }

    @Override
    public int updateRequestStatus(Map map) {
        return sqlSession.update("kr.or.smartfarm.request.updateRequestStatus", map);
    }
}
