package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

/**
 * 출하요청(주문) DAO 구현체.
 *
 * <p>MyBatis {@link SqlSession}으로 request.xml의 {@code kr.or.smartfarm.request.*}
 * statement를 호출한다. 목록 조회는 PageHelper로 페이징한다
 * (startPage 호출 직후의 selectList가 자동으로 페이징됨).</p>
 */
@Repository
public class RequestDAOImpl implements RequestDAO {

    /** MyBatis SQL 실행 세션 */
    @Autowired
    SqlSession sqlSession;

    /** 전체 출하요청 목록 — PageHelper로 5건씩 페이징 */
    @Override
    public List selectAll(int pageNum) {
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.request.loadRequest");
    }

    /** 복합 조건 검색 — map의 page로 PageHelper 페이징 후 검색 */
    @Override
    public List searchRequest(Map map) {
        int pageNum = (Integer) map.get("page");
        PageHelper.startPage(pageNum, 5);
        return sqlSession.selectList("kr.or.smartfarm.request.searchRequest", map);
    }

    /** 거래처 검색 (부분 일치) */
    @Override
    public List searchVender(String keyword) {
        return sqlSession.selectList("kr.or.smartfarm.request.searchVender", keyword);
    }

    /** 완제품(PRODUCT) 품목 목록 */
    @Override
    public List loadProducts() {
        return sqlSession.selectList("kr.or.smartfarm.request.loadProducts");
    }

    /** 신규 출하요청 등록 (selectKey로 shipment_request_num 채번 후 map에 반영) */
    @Override
    public int insertRequest(Map map) {
        return sqlSession.insert("kr.or.smartfarm.request.insertRequest", map);
    }

    /** request_id로 단건 상세 조회 */
    @Override
    public Map selectDetail(String requestId) {
        return sqlSession.selectOne("kr.or.smartfarm.request.loadRequestDetail", requestId);
    }

    /** 요청 상태 갱신 (status_name → status_num 서브쿼리 매핑) */
    @Override
    public int updateRequestStatus(Map map) {
        return sqlSession.update("kr.or.smartfarm.request.updateRequestStatus", map);
    }

    /** 출하요청 담당자 emp_num 조회 (VENDER.emp_num, 취소 권한 검증용) */
    @Override
    public String getEmpNum(String requestId) {
        return sqlSession.selectOne("kr.or.smartfarm.request.getEmpNum", requestId);
    }
}
