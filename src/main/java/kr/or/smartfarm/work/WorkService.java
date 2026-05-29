package kr.or.smartfarm.work;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.prod.SelectOptionDTO;

/**
 * WorkService - 작업지시(Work Order) 비즈니스 로직 인터페이스.
 *
 * 컨트롤러(WorkController)가 호출하며, 실제 구현은 WorkServiceImpl이 담당한다.
 * 모든 상태 변경 메서드는 DB 레벨에서 완료·취소 상태이면 변경이 차단된다.
 */
public interface WorkService {

    /**
     * 작업지시 목록을 페이징·필터 조건에 따라 조회한다.
     * 페이징 계산(startRow, endRow, totalPages 등)은 서비스 내부에서 처리된다.
     *
     * @param page 페이징 및 검색 필터 정보 (WorkPageDTO)
     * @return 작업지시 목록 (WorkDTO 리스트)
     */
    List<WorkDTO> getList(WorkPageDTO page);

    /**
     * 특정 작업지시의 상세 정보를 조회한다.
     *
     * @param work_order_id 조회할 작업지시 ID (예: "PP-2024-001-1")
     * @return 작업지시 상세 DTO, 존재하지 않으면 null
     */
    WorkDTO selectOne(String work_order_id);

    /**
     * 새 작업지시를 등록한다.
     * work_order_id는 DB selectKey를 통해 자동 생성(plan_id + '-' + 순번)된다.
     *
     * @param workDTO 등록할 작업지시 정보 (plan_num, emp_num, order_qty, order_start, content)
     * @return INSERT 결과 행 수 (1: 성공, 0: 생산계획이 취소/완료/기간 초과로 등록 불가)
     */
    int create(WorkDTO workDTO);

    /**
     * 작업지시 상태를 '취소'로 변경한다.
     * 이미 완료·취소 상태이면 DB에서 UPDATE가 무시된다.
     *
     * @param work_order_id 취소할 작업지시 ID
     */
    void cancel(String work_order_id);

    /**
     * 작업지시 상태를 '대기'에서 '진행'으로 변경한다.
     * 컨트롤러에서 오늘 날짜와 order_start 일치 여부를 검증한 후 호출된다.
     *
     * @param work_order_id 시작할 작업지시 ID
     */
    void start(String work_order_id);

    /**
     * 작업지시 상태를 '진행'에서 '완료'로 변경한다. (생산실적 없는 단순 종료)
     *
     * @param work_order_id 종료할 작업지시 ID
     */
    void complete(String work_order_id);

    /**
     * 생산실적을 처리한다. (BOM 기반 재고 차감 + LOT 생성)
     *
     * 처리 순서:
     *  1. BOM 재료 목록 조회
     *  2. 재료별 재고 사전 검증 (부족 시 RuntimeException("stock_error") 발생)
     *  3. 생산 결과 LOT 신규 생성
     *  4. 재료별 FIFO 차감 + io 출고 기록 + lot_relation 기록
     *  5. work_order 완료 처리 + 생산계획 완료 여부 갱신
     *
     * @param work_order_id 생산실적을 처리할 작업지시 ID
     * @throws RuntimeException "stock_error" - BOM 기준 재고가 부족할 때
     */
    void produce(String work_order_id);

    /**
     * 담당자 선택 옵션 목록을 반환한다. (등록 모달 드롭다운용)
     *
     * @return 담당자 목록 (num: emp_num, name: ename)
     */
    List<SelectOptionDTO> getEmpOptions();

    /**
     * 생산계획 선택 옵션 목록을 반환한다. (등록 모달 드롭다운용, 취소 제외)
     *
     * @return 생산계획 목록 (num: plan_num, name: plan_id)
     */
    List<SelectOptionDTO> getPlanOptions();

    /**
     * 품목 선택 옵션 목록을 반환한다. (검색 필터 드롭다운용, PRODUCT + SEMIPRODUCT)
     *
     * @return 품목 목록 (num: item_num, name: item_name, type: item_type)
     */
    List<SelectOptionDTO> getItemOptions();

    /**
     * 등록 모달에서 사용하는 생산계획 AJAX 검색 결과를 반환한다.
     * 내부적으로 plan_start 지난 '대기' 상태를 '진행'으로 동기화 후 조회한다.
     *
     * @param keyword  검색어 (계획번호 또는 품목명 부분 일치)
     * @param page     요청 페이지 번호 (1부터 시작)
     * @return Map { list, currentPage, totalPages, totalCount }
     */
    Map<String, Object> searchPlans(String keyword, int page);

    /** 품목별 공정 목록 조회 (작업순서 오름차순, 작업지시 상세 페이지용) */
    List<Map<String, Object>> getProcessesByItem(int item_num);
}
