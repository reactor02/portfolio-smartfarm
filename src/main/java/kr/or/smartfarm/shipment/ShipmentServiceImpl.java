package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShipmentServiceImpl implements ShipmentService {

    @Autowired
    ShipmentDAO shipmentDAO;

    @Override
    public List selectAll(int pageNum) {
        return shipmentDAO.selectAll(pageNum);
    }

    @Override
    public List searchShipment(Map map) {
        return shipmentDAO.searchShipment(map);
    }
}
