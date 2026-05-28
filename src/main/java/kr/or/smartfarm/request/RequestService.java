package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

public interface RequestService {
    public List selectAll(int pageNum);
    public List searchRequest(Map map);
    public List searchVender(String keyword);
    public List loadProducts();
    public int insertRequest(Map map);
    public Map selectDetail(String requestId);
    public int hasShipment(String shipmentRequestNum);
    public int updateRequestStatus(Map map);
}
