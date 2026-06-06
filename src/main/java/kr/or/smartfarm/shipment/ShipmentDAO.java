package kr.or.smartfarm.shipment;

import java.util.Date;
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
    public int insertShipment(Map map);
    public int insertShipmentLot(Map map);
    public int updateRequestStatusToDispatch(String shipmentRequestNum);
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
    public List loadWorkerList();

    // 출하확정 분할
    public int insertSplitLot(Map map);
    public int insertLotSplit(Map map);
    public int updateShipmentLotRef(Map map);

    /** 출하 담당자 emp_num 조회 (취소/확정 권한 검증용) */
    public String getEmpNum(String shipmentId);

    /** 출하 실무자 worker_num 조회 (출하확정 권한 검증용) */
    public String getWorkerNum(String shipmentId);

    /** 선택한 LOT의 유통기한(expiry_date) 조회 */
    public Date getLotExpiry(int lotNum);

    /** 출하에 배정된 LOT들의 유통기한(expiry_date) 목록 조회 */
    public List<Date> getShipmentLotExpiries(int shipmentNum);

    /** 해당 LOT이 속한 품목의 타입(item.type) 조회 */
    public String getLotItemType(int lotNum);

    /** 해당 lot_num이 shipment_lot에 배정된 건수 조회 (중복 배정 검증용) */
    public int countShipmentLotByLotNum(int lotNum);

    /** 해당 품목의 출하 가능 후보 LOT 목록(FIFO) 조회 — PRODUCT·보유>0·유통기한 미경과·미배정·qc PASS */
    public List<ShippableLotDTO> selectShippableLots(int itemNum);

    /** 확정 시 분할 판단용 — 단건 LOT의 current_qty/item_num/expiry_date 조회 */
    public Map selectLotForConfirm(int lotNum);
}
