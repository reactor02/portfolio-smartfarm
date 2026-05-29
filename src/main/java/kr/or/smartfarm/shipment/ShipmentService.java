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
    /** 출하지시 — SHIPMENT 등록 + FIFO LOT 배정 + 요청 상태 변경 (트랜잭션) */
    public void dispatchShipment(Map map);
    /** 출하확정 — 롯 분할/재고 차감/IO·lot_relation 기록 (트랜잭션, 중복·음수재고 방어) */
    public void confirmShipment(Map map);
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
}
