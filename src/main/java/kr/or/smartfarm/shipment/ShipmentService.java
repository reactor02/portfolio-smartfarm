package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

public interface ShipmentService {
    public List selectAll(int pageNum);
    public List searchShipment(Map map);
    public Map selectDetail(String shipmentId);
    public List selectLots(int shipmentNum);
    public void dispatchShipment(Map map);
    public void confirmShipment(Map map);
    public void cancelShipment(Map map);
    public List selectByRequestNum(String shipmentRequestNum);
    public List loadItems();
    public List loadPendingRequests();
    public List loadEmpList();
}
