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

    @Override
    public Map selectDetail(String shipmentId) {
        return sqlSession.selectOne("kr.or.smartfarm.shipment.loadShipmentDetail", shipmentId);
    }

    @Override
    public List selectLots(int shipmentNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadShipmentLots", shipmentNum);
    }

    @Override
    public List getAvailableLots(int itemNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.getAvailableLotsForShipment", itemNum);
    }

    @Override
    public int insertShipment(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertShipment", map);
    }

    @Override
    public int insertShipmentLot(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertShipmentLot", map);
    }

    @Override
    public int updateRequestStatusToDispatch(String shipmentRequestNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateRequestStatusToDispatch", shipmentRequestNum);
    }

    @Override
    public List getShipmentLots(int shipmentNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.getShipmentLots", shipmentNum);
    }

    @Override
    public int deductLotQty(Map map) {
        return sqlSession.update("kr.or.smartfarm.shipment.deductLotQty", map);
    }

    @Override
    public int insertShipmentIo(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertShipmentIo", map);
    }

    @Override
    public int confirmShipmentStatus(int shipmentNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.confirmShipmentStatus", shipmentNum);
    }

    @Override
    public int updateRequestStatusToComplete(String shipmentRequestNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateRequestStatusToComplete", shipmentRequestNum);
    }

    @Override
    public int cancelShipmentStatus(int shipmentNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.cancelShipmentStatus", shipmentNum);
    }

    @Override
    public int updateRequestStatusToRollback(String shipmentRequestNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateRequestStatusToRollback", shipmentRequestNum);
    }

    @Override
    public List selectByRequestNum(String shipmentRequestNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadShipmentsByRequest", shipmentRequestNum);
    }

    @Override
    public List loadItems() {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadItems");
    }

    @Override
    public List loadPendingRequests() {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadPendingRequests");
    }

    @Override
    public List loadEmpList() {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadEmpList");
    }
}
