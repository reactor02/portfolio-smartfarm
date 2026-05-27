package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

public interface ShipmentService {
    public List selectAll(int pageNum);
    public List searchShipment(Map map);
}
