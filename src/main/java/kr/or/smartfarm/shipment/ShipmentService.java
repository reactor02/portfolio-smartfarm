package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

/**
 * 출하 서비스 인터페이스. 구현은 {@link ShipmentServiceImpl}.
 *
 * <p>dispatch/confirm/cancel 3개 메서드는 트랜잭션 + 방어코딩이 적용된
 * 핵심 비즈니스 로직이다(FIFO LOT 배정 / 롯 분할·재고 차감 / 상태 가드).</p>
 */
public interface ShipmentService {
    /** 전체 출하 목록 (PageHelper 페이징) */
    public List selectAll(int pageNum);
    /** 복합 조건 검색 */
    public List searchShipment(Map map);
    /** shipmentId로 단건 상세 조회 */
    public Map selectDetail(String shipmentId);
    /** 출하에 배정된 LOT 목록 */
    public List selectLots(int shipmentNum);
    /** 출하지시 — SHIPMENT(shell) 등록 + 요청 상태 변경 (트랜잭션, 자동배정 없음) */
    public void dispatchShipment(Map map);
    /** 출하취소 — '출하대기' 건만 취소 + 요청 상태 롤백 (트랜잭션) */
    public void cancelShipment(Map map);
    /** 특정 요청번호에 연계된 출하 목록 */
    public List selectByRequestNum(String shipmentRequestNum);
    /** 검색 필터 품목 옵션 */
    public List loadItems();
    /** 출하지시 대상(출하대기) 요청 목록 */
    public List loadPendingRequests();
    /** 담당자 옵션 목록 */
    public List loadEmpList();
    /** 실무자 옵션 목록 (e_level=1, 재직자) */
    public List loadWorkerList();

    /** 출하 담당자 emp_num 조회 (취소/확정 권한 검증용) */
    public String getEmpNum(String shipmentId);

    /** 출하 실무자 worker_num 조회 (출하확정 권한 검증용) */
    public String getWorkerNum(String shipmentId);

    /**
     * 선택한 LOT의 유통기한 검증.
     * 이미 지났으면(유통기한 &lt; sysdate) -1, 아니면 유통기한(Date)을 반환한다.
     */
    public Object selectLotExpiry(int lotNum);

    /**
     * 출하에 배정된 LOT 중 유통기한이 sysdate보다 늦은(아직 안 지난, 유효한) 롯이
     * 하나도 없으면 예외를 던진다.
     */
    public void validateUsableLotExists(int shipmentNum);

    /**
     * 출하 배정 전 LOT 검증.
     * 품목 타입이 PRODUCT가 아니거나, 이미 shipment_lot에 배정된 롯이면 예외를 던진다.
     */
    public void validateLotForShipment(int lotNum);

    /**
     * 후보 LOT들 중 출하 가능한(PRODUCT 타입 + 미배정) 롯만 골라 list로 반환한다.
     * 통과한 롯이 하나도 없으면 예외를 던진다.
     */
    public List<Integer> collectShippableLots(List<Integer> lotNums);

    /**
     * 해당 품목의 출하 가능 후보 LOT(FIFO)을 조회해 반환한다(없으면 빈 리스트).
     * 상세 페이지 수동 선택 UI가 채울 후보 목록.
     */
    public List<ShippableLotDTO> selectShippableLots(int itemNum);

    /**
     * 출하확정(수동 LOT 선택). 사용자가 고른 {lot_num, qty} 선택으로 출고/분할 처리한다.
     * 합계가 plan_qty 미만이면 force=true 일 때만 부분출하를 허용한다.
     */
    public void confirmShipmentManual(int shipmentNum, String shipmentRequestNum,
                                      int empNum, int planQty, List<Map> selections, boolean force);
}
