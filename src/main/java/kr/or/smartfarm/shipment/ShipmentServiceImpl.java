package kr.or.smartfarm.shipment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Override
    public Map selectDetail(String shipmentId) {
        return shipmentDAO.selectDetail(shipmentId);
    }

    @Override
    public List selectLots(int shipmentNum) {
        return shipmentDAO.selectLots(shipmentNum);
    }

    @Override
    @Transactional
    public void dispatchShipment(Map map) {
        String shipmentRequestNum = (String) map.get("shipment_request_num");
        int itemNum  = (Integer) map.get("item_num");
        int planQty  = (Integer) map.get("plan_qty");
        int empNum   = (Integer) map.get("emp_num");

        // 1. Insert SHIPMENT record (selectKey gives back shipment_num)
        shipmentDAO.insertShipment(map);
        int shipmentNum = (Integer) map.get("shipment_num");

        // 2. FIFO LOT 배정
        List<Map> availableLots = shipmentDAO.getAvailableLots(itemNum);
        int remaining = planQty;
        for (Map lot : availableLots) {
            if (remaining <= 0) break;

            int lotNum     = ((Number) lot.get("LOT_NUM")).intValue();
            int currentQty = ((Number) lot.get("CURRENT_QTY")).intValue();
            int allocQty   = Math.min(remaining, currentQty);

            Map slMap = new HashMap();
            slMap.put("shipment_num", shipmentNum);
            slMap.put("lot_num",      lotNum);
            slMap.put("qty",          allocQty);
            shipmentDAO.insertShipmentLot(slMap);

            remaining -= allocQty;
        }

        // 3. Request status → 출하대기
        shipmentDAO.updateRequestStatusToDispatch(shipmentRequestNum);
    }

    @Override
    @Transactional
    public void confirmShipment(Map map) {
        int    shipmentNum        = (Integer) map.get("shipment_num");
        String shipmentRequestNum = (String)  map.get("shipment_request_num");
        int    empNum             = (Integer) map.get("emp_num");

        // 1. LOT별 수량 차감 + IO 출고 이력
        List<Map> lots = shipmentDAO.getShipmentLots(shipmentNum);
        for (Map lot : lots) {
            int lotNum = ((Number) lot.get("LOT_NUM")).intValue();
            int qty    = ((Number) lot.get("QTY")).intValue();

            Map deductMap = new HashMap();
            deductMap.put("lot_num", lotNum);
            deductMap.put("qty",     qty);
            shipmentDAO.deductLotQty(deductMap);

            Map ioMap = new HashMap();
            ioMap.put("lot_num", lotNum);
            ioMap.put("qty",     qty);
            ioMap.put("emp_num", empNum);
            shipmentDAO.insertShipmentIo(ioMap);
        }

        // 2. 출하 상태 → 완료
        shipmentDAO.confirmShipmentStatus(shipmentNum);

        // 3. Request 상태 → 출하완료
        shipmentDAO.updateRequestStatusToComplete(shipmentRequestNum);
    }

    @Override
    @Transactional
    public void cancelShipment(Map map) {
        int    shipmentNum        = (Integer) map.get("shipment_num");
        String shipmentRequestNum = (String)  map.get("shipment_request_num");

        // 1. 출하 상태 → 취소
        shipmentDAO.cancelShipmentStatus(shipmentNum);

        // 2. Request 상태 → 접수 (롤백)
        shipmentDAO.updateRequestStatusToRollback(shipmentRequestNum);
    }

    @Override
    public List selectByRequestNum(String shipmentRequestNum) {
        return shipmentDAO.selectByRequestNum(shipmentRequestNum);
    }

    @Override
    public List loadItems() {
        return shipmentDAO.loadItems();
    }

    @Override
    public List loadPendingRequests() {
        return shipmentDAO.loadPendingRequests();
    }

    @Override
    public List loadEmpList() {
        return shipmentDAO.loadEmpList();
    }
}
