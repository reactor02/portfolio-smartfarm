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
     * 생산투입(출고) — 입력 수량(qty)만큼 BOM 자재를 FIFO로 출고하여 작업지시에 묶는다.
     *
     * 처리 순서:
     *  1. 입력 수량 검증 (1 ≤ qty ≤ min(재고기준 최대, order_qty − input_qty)이 아니면 "qty_error")
     *  2. BOM 자재별 FIFO(QC합격·유통기한 유효) 차감 + io 출고 + order_lot 기록 + stock 차감
     *  3. work_order.input_qty += qty
     *
     * @param work_order_id 작업지시 ID
     * @param qty           이번에 투입(출고)할 생산 수량
     * @throws RuntimeException "qty_error"
     */
    void input(String work_order_id, int qty);

    /**
     * 작업완료(생산) — 이미 투입된 분량(input_qty − current_qty)만큼 완제품 LOT을 생성한다.
     * 자재는 생산투입 단계에서 이미 차감되었으므로 재차감하지 않는다.
     *
     * @param work_order_id 작업지시 ID
     * @throws RuntimeException "nothing" - 투입된(미생산) 분량이 없을 때
     */
    void produce(String work_order_id);

    /**
     * 투입취소 — 아직 생산되지 않은(남은) 투입 자재만 환원한다.
     * 환원량 = 자재별 required_qty × (input_qty − current_qty). 이미 소모된 분량은 환원하지 않는다.
     *
     * @param work_order_id 작업지시 ID
     */
    void cancelInput(String work_order_id);

    /**
     * 상세 페이지의 소모자재/재고/투입·생산 가능 수량 정보를 계산해 반환한다.
     * 가용재고는 QC 합격 FIFO LOT 합계를 기준으로 한다.
     *
     * @param work_order_id 작업지시 ID
     * @return Map { materials:[...], remaining, maxProducible, inputtable, maxInput, pendingProduce, input_qty }
     */
    Map<String, Object> getProduceInfo(String work_order_id);

    /** 작업지시에 투입된 LOT 목록 조회 (상세 표시용) */
    List<Map<String, Object>> getOrderLots(int order_num);

    /**
     * 담당자 선택 옵션 목록을 반환한다. (등록 모달 드롭다운용)
     *
     * @return 담당자 목록 (num: emp_num, name: ename)
     */
    List<SelectOptionDTO> getEmpOptions();

    /**
     * 실무자 선택 옵션 목록을 반환한다. (e_level=1, 재직자만)
     *
     * @return 실무자 목록 (num: emp_num, name: ename)
     */
    List<SelectOptionDTO> getWorkerOptions();

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

    /**
     * 등록 모달에서 사용하는 실무자 AJAX 검색 결과를 반환한다.
     * 부서 3·5(순화·조직배양) 소속 재직자만 검색 대상이다.
     *
     * @param keyword  검색어 (사번 또는 이름 부분 일치)
     * @param page     요청 페이지 번호 (1부터 시작)
     * @return Map { list, currentPage, totalPages, totalCount }
     */
    Map<String, Object> searchWorkers(String keyword, int page);

    /** 품목별 공정 목록 조회 (작업순서 오름차순, 작업지시 상세 페이지용) */
    List<Map<String, Object>> getProcessesByItem(int item_num);

    /**
     * 작업지시 담당자 emp_num 조회 (취소/완료 권한 검증용)
     *
     * @param work_order_id 작업지시 ID
     * @return 담당자 emp_num 문자열
     */
    String getEmpNum(String work_order_id);

    /**
     * 작업지시 실무자 worker_num 조회 (시작/완료/생산 권한 검증용)
     *
     * @param work_order_id 작업지시 ID
     * @return 실무자 worker_num 문자열
     */
    String getWorkerNum(String work_order_id);
}
