package kr.or.smartfarm.prod;

import java.util.List;
import java.util.Map;

/**
 * 생산계획(Production Plan) 서비스 인터페이스
 *
 * - 생산계획 CRUD 및 관련 조회 기능을 정의한다.
 * - ProdServiceImpl 이 이 인터페이스를 구현하며, 컨트롤러에서 이 타입으로 주입된다.
 */
public interface ProdService {

    /**
     * 생산계획 목록 조회 (페이징 + 검색 조건 적용)
     *
     * @param page  검색 조건 및 페이지 정보가 담긴 DTO
     * @return 조회된 생산계획 목록 (각 항목에 total_count 포함)
     */
    List<ProdDTO>         getList(ProdPageDTO page);

    /**
     * 생산계획 단건 조회
     *
     * @param plan_id  조회할 생산계획 식별자 (예: "A", "B", ...)
     * @return 해당 생산계획 DTO, 존재하지 않으면 null
     */
    ProdDTO               selectOne(String plan_id);

    /**
     * 생산계획 신규 등록
     *
     * @param prodDTO  등록할 생산계획 데이터 (plan_id 는 insert 후 자동 채워짐)
     * @return 영향받은 행 수
     */
    int                   create(ProdDTO prodDTO);

    /**
     * 담당자(사원) 드롭다운 옵션 목록 조회
     *
     * @return num(emp_num), name(ename) 을 담은 SelectOptionDTO 목록
     */
    List<SelectOptionDTO> getEmpList();

    /**
     * 시설(설비) 드롭다운 옵션 목록 조회
     *
     * @return num(facility_num), name(facility_name) 을 담은 SelectOptionDTO 목록
     */
    List<SelectOptionDTO> getFacilityOptions();

    /**
     * 품목 드롭다운 옵션 목록 조회 (PRODUCT, SEMIPRODUCT 만 포함)
     *
     * @return num(item_num), name(item 이름), type(품목 유형) 을 담은 SelectOptionDTO 목록
     */
    List<SelectOptionDTO> getItemOptions();

    /**
     * 활성 품목 드롭다운 옵션 목록 조회 (등록 모달용, item_status = 'Y' 만 포함)
     *
     * @return num(item_num), name(item 이름), type(품목 유형) 을 담은 SelectOptionDTO 목록
     */
    List<SelectOptionDTO> getActiveItemOptions();

    /**
     * 생산계획 상태 변경
     *
     * @param plan_id  상태를 변경할 생산계획 식별자
     * @param status   변경할 상태값 (예: "취소")
     */
    void                  updateStatus(String plan_id, String status);

    /**
     * 특정 생산계획에 속한 작업지시(work_order) 목록 조회 (페이징)
     *
     * @param plan_num  생산계획 일련번호 (PK)
     * @param page      조회 페이지 번호
     * @return list, totalPages, totalCount, currentPage 키를 담은 Map
     */
    Map<String, Object>   getWorkOrders(int plan_num, int page);

    /**
     * 생산계획 담당자 emp_num 조회 (취소 권한 검증용)
     *
     * @param plan_id 생산계획 식별자
     * @return 담당자 emp_num 문자열
     */
    String getEmpNum(String plan_id);
}
