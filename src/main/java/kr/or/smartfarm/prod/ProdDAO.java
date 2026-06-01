package kr.or.smartfarm.prod;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.work.WorkDTO;

/**
 * 생산계획(Production Plan) DAO 인터페이스
 *
 * - MyBatis SqlSession 을 통해 prod.xml 매퍼에 정의된 SQL 을 실행한다.
 * - ProdDAOImpl 이 이 인터페이스를 구현하며, 서비스 계층에서 이 타입으로 주입된다.
 * - 네임스페이스: kr.or.smartfarm.prod (prod.xml mapper namespace 와 일치)
 */
public interface ProdDAO {

    /**
     * 생산계획 목록 조회 (페이징 + 검색 조건)
     *
     * @param page  검색 조건 및 startRow/endRow 가 세팅된 페이지 DTO
     * @return 생산계획 목록 (각 행에 total_count 포함)
     */
    public List<ProdDTO>         getList(ProdPageDTO page);

    /**
     * 담당자(사원) 드롭다운 옵션 목록 조회
     *
     * @return num(emp_num), name(ename) 을 담은 SelectOptionDTO 목록
     */
    public List<SelectOptionDTO> getEmpList();

    /**
     * 시설(설비) 드롭다운 옵션 목록 조회
     *
     * @return num(facility_num), name(facility_name) 을 담은 SelectOptionDTO 목록
     */
    public List<SelectOptionDTO> getFacilityOptions();

    /**
     * 품목 드롭다운 옵션 목록 조회 (PRODUCT, SEMIPRODUCT 만)
     *
     * @return num(item_num), name(품목명), type(품목 유형) 을 담은 SelectOptionDTO 목록
     */
    public List<SelectOptionDTO> getItemOptions();

    /**
     * 생산계획 단건 조회
     *
     * @param plan_id  조회할 생산계획 식별자
     * @return 해당 생산계획 DTO, 없으면 null
     */
    public ProdDTO               getSelectOne(String plan_id);

    /**
     * 생산계획 신규 등록
     *
     * - insert 실행 전 selectKey 로 plan_id 를 자동 생성한다.
     * - plan_num 은 PROD_SEQ 시퀀스로 자동 부여된다.
     *
     * @param prodDTO  등록할 생산계획 데이터
     * @return 영향받은 행 수
     */
    public int                   create(ProdDTO prodDTO);

    /**
     * 생산계획 상태 변경
     *
     * @param prodDTO  plan_id 와 변경할 plan_status 가 세팅된 DTO
     * @return 영향받은 행 수
     */
    public int                   updateStatus(ProdDTO prodDTO);

    /**
     * "대기" 상태 계획 중 plan_start 가 지난 건을 "진행"으로 일괄 업데이트
     *
     * - 목록 조회 전 서비스 계층에서 호출되어 날짜 기반 상태 자동 동기화를 수행한다.
     *
     * @return 영향받은 행 수
     */
    public int                   syncPlanStatus();

    /**
     * 특정 생산계획에 속한 작업지시 목록 조회 (페이징)
     *
     * @param params  plan_num, startRow, endRow 를 담은 파라미터 Map
     * @return 작업지시 목록 (각 행에 total_count 포함)
     */
    public List<WorkDTO>         getWorkOrders(Map<String, Object> params);

    /**
     * 생산계획 담당자 emp_num 조회 (취소 권한 검증용)
     *
     * @param plan_id 생산계획 식별자
     * @return 담당자 emp_num 문자열, 없으면 null
     */
    public String getEmpNum(String plan_id);
}
