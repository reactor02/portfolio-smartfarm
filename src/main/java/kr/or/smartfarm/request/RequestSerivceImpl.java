package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RequestSerivceImpl implements RequestService {

    @Autowired
    RequestDAO requestDAO;

    @Override
    public List selectAll(int pageNum) {
        return requestDAO.selectAll(pageNum);
    }

    @Override
    public List searchRequest(Map map) {
        return requestDAO.searchRequest(map);
    }

    @Override
    public List searchVender(String keyword) {
        return requestDAO.searchVender(keyword);
    }

    @Override
    public List loadProducts() {
        return requestDAO.loadProducts();
    }

    @Override
    public int insertRequest(Map map) {
        return requestDAO.insertRequest(map);
    }

    @Override
    public Map selectDetail(String requestId) {
        return requestDAO.selectDetail(requestId);
    }

    @Override
    public int hasShipment(String shipmentRequestNum) {
        return requestDAO.hasShipment(shipmentRequestNum);
    }

    @Override
    public int updateRequestStatus(Map map) {
        return requestDAO.updateRequestStatus(map);
    }
}
