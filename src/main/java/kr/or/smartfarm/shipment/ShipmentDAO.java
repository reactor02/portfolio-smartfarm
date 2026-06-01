package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

/**
 * 출하 데이터 접근 인터페이스. 구현은 {@link ShipmentDAOImpl}.
 *
 * <p>상태 변경/수량 차감 메서드(confirmShipmentStatus, cancelShipmentStatus,
 * deductLotQty 등)는 영향 행 수를 반환하여 서비스 계층의 방어코딩에 사용된다.</p>
 */
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

    /** 출하 담당자 emp_num 조회 (취소/확정 권한 검증용) */
    public String getEmpNum(String shipmentId);
}
