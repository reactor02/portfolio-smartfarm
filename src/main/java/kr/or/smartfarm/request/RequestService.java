package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

/**
 * 출하요청(주문) 비즈니스 로직 인터페이스.
 *
 * 컨트롤러(RequestController)에서 직접 참조하며,
 * 실제 구현은 RequestSerivceImpl이 담당한다.
 * DAO 호출 외의 추가 비즈니스 규칙이 필요한 경우 이 계층에서 처리한다.
 */
public interface RequestService {

    /**
     * 전체 출하요청 목록을 페이징하여 반환한다.
     *
     * @param pageNum 조회할 페이지 번호 (1부터 시작, PageHelper가 5건씩 처리)
     * @return 출하요청 목록 (hashMap 리스트)
     */
    public List selectAll(int pageNum);

    /**
     * 조건 검색을 통해 출하요청 목록을 반환한다.
     *
     * @param map 검색 조건 Map (page, type, keyword, status, sDate, eDate)
     * @return 조건에 맞는 출하요청 목록
     */
    public List searchRequest(Map map);

    /**
     * 거래처명 키워드로 거래처를 검색하여 반환한다.
     * 등록 모달의 거래처 드롭다운 AJAX에서 사용된다.
     *
     * @param keyword 거래처명 검색어 (빈 문자열이면 전체 반환)
     * @return 거래처 목록
     */
    public List searchVender(String keyword);

    /**
     * 등록 모달에서 선택할 수 있는 완제품(PRODUCT) 목록을 반환한다.
     *
     * @return 완제품 목록 (item_num, name)
     */
    public List loadProducts();

    /**
     * 신규 출하요청을 DB에 등록한다.
     * MyBatis selectKey가 shipment_request_num을 채번하여 map에 다시 담아준다.
     *
     * @param map 등록 데이터 Map (vender_num, item_num, request_date, due_date, request_qty)
     *            INSERT 후 map에 shipment_request_num이 추가됨
     * @return INSERT 영향 행 수
     */
    public int insertRequest(Map map);

    /**
     * request_id로 출하요청 단건 상세 정보를 조회한다.
     *
     * @param requestId 요청 ID (예: REQ0001)
     * @return 상세 정보 Map, 없으면 null
     */
    public Map selectDetail(String requestId);

    /**
     * 해당 출하요청에 유효한(취소 아닌) 출하지시가 존재하는지 확인한다.
     * 반환값이 0이면 출하지시 버튼을 표시한다.
     *
     * @param shipmentRequestNum 출하요청 번호 (SREQ0001 형태)
     * @return 유효한 출하지시 건수 (0: 없음, 1 이상: 있음)
     */
    public int hasShipment(String shipmentRequestNum);

    /**
     * 출하요청의 상태를 변경한다. (취소, 출하대기, 출하완료 등)
     *
     * @param map 상태 변경 데이터 Map (shipment_request_num, status_name)
     * @return UPDATE 영향 행 수
     */
    public int updateRequestStatus(Map map);
}
