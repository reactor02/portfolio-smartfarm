package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 출하요청(주문) 서비스 구현체.
 *
 * <p>{@link RequestService} 인터페이스를 구현하며, 별도 비즈니스 로직 없이
 * {@link RequestDAO}로 위임만 하는 얇은 계층이다. (트랜잭션이 필요한 출하지시는
 * ShipmentService에서 처리)</p>
 */
@Service
public class RequestSerivceImpl implements RequestService {

    /** 출하요청 데이터 접근 DAO */
    @Autowired
    RequestDAO requestDAO;

    /** 전체 출하요청 목록 (PageHelper 페이징) */
    @Override
    public List selectAll(int pageNum) {
        return requestDAO.selectAll(pageNum);
    }

    /** 복합 조건(상태/납기/키워드) 검색 */
    @Override
    public List searchRequest(Map map) {
        return requestDAO.searchRequest(map);
    }

    /** 거래처 검색 (등록 모달 드롭다운용) */
    @Override
    public List searchVender(String keyword) {
        return requestDAO.searchVender(keyword);
    }

    /** 완제품(PRODUCT) 품목 목록 (등록 모달용) */
    @Override
    public List loadProducts() {
        return requestDAO.loadProducts();
    }

    /** 신규 출하요청 등록 (selectKey로 shipment_request_num 채번) */
    @Override
    public int insertRequest(Map map) {
        return requestDAO.insertRequest(map);
    }

    /** request_id로 단건 상세 조회 */
    @Override
    public Map selectDetail(String requestId) {
        return requestDAO.selectDetail(requestId);
    }

    /** 요청 상태 변경 (status_name으로 status_num을 서브쿼리 조회하여 갱신) */
    @Override
    public int updateRequestStatus(Map map) {
        return requestDAO.updateRequestStatus(map);
    }

    /** 출하요청 담당자 emp_num 조회 (VENDER.emp_num, 취소 권한 검증용) */
    @Override
    public String getEmpNum(String requestId) {
        return requestDAO.getEmpNum(requestId);
    }
}
