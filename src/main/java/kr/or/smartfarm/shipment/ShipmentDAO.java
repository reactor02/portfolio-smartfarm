package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

public interface ShipmentDAO {
    public List selectAll(int pageNum);
    public List searchShipment(Map map);
    public Map selectDetail(String shipmentId);
    public List selectLots(int shipmentNum);
    public List getAvailableLots(int itemNum);
    public int insertShipment(Map map);
    public int insertShipmentLot(Map map);
    public int updateRequestStatusToDispatch(String shipmentRequestNum);
    public List getShipmentLots(int shipmentNum);
    public int deductLotQty(Map map);
    public int insertShipmentIo(Map map);
    public int confirmShipmentStatus(int shipmentNum);
    public int updateRequestStatusToComplete(String shipmentRequestNum);
    public int cancelShipmentStatus(int shipmentNum);
    public int updateRequestStatusToRollback(String shipmentRequestNum);
    public List selectByRequestNum(String shipmentRequestNum);
    public List loadItems();
    public List loadPendingRequests();
    public List loadEmpList();

    // 출하확정 분할
    public int insertSplitLot(Map map);
    public int insertLotRelationForShipment(Map map);
    public int updateShipmentLotRef(Map map);
}
