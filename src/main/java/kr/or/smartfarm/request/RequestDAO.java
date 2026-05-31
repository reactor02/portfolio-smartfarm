package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

/**
 * 출하요청(주문) 데이터 접근 인터페이스. 구현은 {@link RequestDAOImpl}.
 */
public interface RequestDAO {
    /** 전체 목록 (PageHelper 페이징) */
    public List selectAll(int pageNum);
    /** 복합 조건 검색 */
    public List searchRequest(Map map);
    /** 거래처 검색 */
    public List searchVender(String keyword);
    /** 완제품 품목 목록 */
    public List loadProducts();
    /** 신규 요청 등록 (selectKey 채번) */
    public int insertRequest(Map map);
    /** 단건 상세 조회 */
    public Map selectDetail(String requestId);
/** 요청 상태 갱신 */
    public int updateRequestStatus(Map map);
}
