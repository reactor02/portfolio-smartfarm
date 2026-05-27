package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class ShipmentDAOImpl implements ShipmentDAO {

    @Autowired
    SqlSession sqlSession;

    @Override
    public List selectAll(int pageNum) {
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadShipment");
    }

    @Override
    public List searchShipment(Map map) {
        int pageNum = (Integer) map.get("page");
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.shipment.searchShipment", map);
    }
}
