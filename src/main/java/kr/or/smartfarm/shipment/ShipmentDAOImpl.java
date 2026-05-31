package kr.or.smartfarm.shipment;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

/**
 * 출하 DAO 구현체.
 *
 * <p>MyBatis {@link SqlSession}으로 shipment.xml의 {@code kr.or.smartfarm.shipment.*}
 * statement를 호출한다. 목록은 PageHelper로 페이징하며, 상태 변경/수량 차감 메서드는
 * 영향 행 수(int)를 반환해 서비스의 방어코딩(선점/재고 가드)에 활용된다.</p>
 */
@Repository
public class ShipmentDAOImpl implements ShipmentDAO {

    /** MyBatis SQL 실행 세션 */
    @Autowired
    SqlSession sqlSession;

    /** 전체 출하 목록 — PageHelper 5건 페이징 */
    @Override
    public List selectAll(int pageNum) {
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadShipment");
    }

    /** 복합 조건 검색 — map의 page로 페이징 */
    @Override
    public List searchShipment(Map map) {
        int pageNum = (Integer) map.get("page");
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.shipment.searchShipment", map);
    }

    /** shipmentId로 단건 상세 조회 */
    @Override
    public Map selectDetail(String shipmentId) {
        return sqlSession.selectOne("kr.or.smartfarm.shipment.loadShipmentDetail", shipmentId);
    }

    /** 출하에 배정된 LOT 목록 */
    @Override
    public List selectLots(int shipmentNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadShipmentLots", shipmentNum);
    }

    /** 출하 배정 가능한 LOT을 FIFO로 조회 (dispatch 시 배정 대상) */
    @Override
    public List getAvailableLots(int itemNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.getAvailableLotsForShipment", itemNum);
    }

    /** SHIPMENT 신규 등록 (selectKey로 shipment_num 채번) */
    @Override
    public int insertShipment(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertShipment", map);
    }

    /** shipment_lot 배정 1건 등록 */
    @Override
    public int insertShipmentLot(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertShipmentLot", map);
    }

    /** 요청 상태 → '출하대기' (dispatch 단계) */
    @Override
    public int updateRequestStatusToDispatch(String shipmentRequestNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateRequestStatusToDispatch", shipmentRequestNum);
    }

    /** 확정 처리 대상 — 출하에 배정된 LOT + 보유 수량(current_qty) 조회 */
    @Override
    public List getShipmentLots(int shipmentNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.getShipmentLots", shipmentNum);
    }

    /** LOT 수량 차감 — [방어] 보유 수량 이상 차감 불가(영향 행 0이면 재고 부족) */
    @Override
    public int deductLotQty(Map map) {
        return sqlSession.update("kr.or.smartfarm.shipment.deductLotQty", map);
    }

    /** 출고 io 이력 기록 (출하/분할) */
    @Override
    public int insertShipmentIo(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertShipmentIo", map);
    }

    /** 출하 상태 → '출하완료' — [방어] '출하대기' 건만 변경(중복 확정 선점, 영향 행 반환) */
    @Override
    public int confirmShipmentStatus(int shipmentNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.confirmShipmentStatus", shipmentNum);
    }

    /** 요청 상태 → '출하완료' (confirm 마무리) */
    @Override
    public int updateRequestStatusToComplete(String shipmentRequestNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateRequestStatusToComplete", shipmentRequestNum);
    }

    /** 출하 상태 → '취소' — [방어] '출하대기' 건만 취소(확정 건 취소 차단, 영향 행 반환) */
    @Override
    public int cancelShipmentStatus(int shipmentNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.cancelShipmentStatus", shipmentNum);
    }

    /** 요청 상태 → '접수'(롤백) — 출하취소 시 원복 */
    @Override
    public int updateRequestStatusToRollback(String shipmentRequestNum) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateRequestStatusToRollback", shipmentRequestNum);
    }

    /** 특정 요청번호에 연계된 출하 목록 */
    @Override
    public List selectByRequestNum(String shipmentRequestNum) {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadShipmentsByRequest", shipmentRequestNum);
    }

    /** 검색 필터 품목 옵션 */
    @Override
    public List loadItems() {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadItems");
    }

    /** 출하지시 대상(출하대기) 요청 목록 */
    @Override
    public List loadPendingRequests() {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadPendingRequests");
    }

    /** 담당자 옵션 목록 */
    @Override
    public List loadEmpList() {
        return sqlSession.selectList("kr.or.smartfarm.shipment.loadEmpList");
    }

    /** 분할 자식 LOT 생성 (출하 수량 < 보유 수량일 때, selectKey로 lot_num 채번) */
    @Override
    public int insertSplitLot(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertSplitLot", map);
    }

    /** lot_relation 등록 — 부모 LOT → 분할 자식 LOT (롯이력 추적) */
    @Override
    public int insertLotRelationForShipment(Map map) {
        return sqlSession.insert("kr.or.smartfarm.shipment.insertLotRelationForShipment", map);
    }

    /** shipment_lot의 배정 LOT 참조를 부모 → 자식으로 교체 */
    @Override
    public int updateShipmentLotRef(Map map) {
        return sqlSession.update("kr.or.smartfarm.shipment.updateShipmentLotRef", map);
    }

    /** 출하 담당자 emp_num 조회 (취소/확정 권한 검증용) */
    @Override
    public String getEmpNum(String shipmentId) {
        return sqlSession.selectOne("kr.or.smartfarm.shipment.getEmpNum", shipmentId);
    }
}
