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

    /* ── 공정별(라우팅) 진행 상태머신 ── */

    /**
     * 작업지시 상세 진입 시 공정기록 행을 보장(없으면 품목 공정 수만큼 '대기'로 생성). 멱등.
     * @param work_order_id 작업지시 ID
     */
    void ensureWorkProcesses(String work_order_id);

    /**
     * 최대생산량/자재 정보 계산. 가용재고는 QC합격 FIFO LOT 합계, order_qty−current_qty로 cap.
     * @return Map { maxProducible, materials:[{name,code,unitQty,needQty,available,shortage}] }
     */
    Map<String, Object> getMaxInfo(String work_order_id);

    /**
     * 공정 소모자재 투입 — 해당 공정 BOM 자재를 생산수량만큼 FIFO 차감하고 work_process_lot에 기록.
     * 첫 투입이면 qty로 배치 생산수량(input_qty) 확정(1 ≤ qty ≤ 최대생산량). 이후 공정은 확정 수량 사용.
     * @throws RuntimeException "state_error" | "qty_error"(부족 자재 목록 동반)
     */
    void inputProcessMaterial(String work_order_id, int process_num, int qty);

    /** 차감 예정 FIFO LOT 미리보기(비차감). @return 자재별 차감 LOT 목록 */
    List<Map<String, Object>> previewProcessLots(String work_order_id, int process_num, int qty);

    /** 공정 시작 ('자재투입'→'진행'). @throws RuntimeException "state_error" */
    void startProcess(String work_order_id, int process_num);

    /** 공정 완료 ('진행'→'완료'). 최종 공정이면 완제품 LOT 확정·생산입고·lot_relation. @throws "state_error" */
    void completeProcess(String work_order_id, int process_num);

    /**
     * 작업완료. 진행 중 공정 있으면 "in_progress". current==order면 완료("ok").
     * current&lt;order면 force=false→"not_full", force=true→완료("ok").
     * @return "ok" | "in_progress" | "not_full"
     */
    String completeWork(String work_order_id, boolean force);

    /**
     * 다음 회차 생산 시작. 현재 회차 전 공정이 완료되고 지시수량에 미달일 때만 가능하며,
     * 새 회차(cycle)의 공정 행을 '대기'로 생성하고 배치수량(input_qty)을 0으로 리셋한다.
     * @throws RuntimeException "state_error" (진행 아님 / 활성 공정 존재 / 지시수량 충족)
     */
    void startNextCycle(String work_order_id);

    /** 작업지시 공정기록 목록 (상세 표시용) */
    List<Map<String, Object>> getWorkProcesses(int order_num);

    /** 작업지시 소모 자재 LOT 목록 (표시용) */
    List<Map<String, Object>> getWorkProcessLots(int order_num);

    /** 현재 진행 액션 상태. @return Map { activeProcessNum, activeFlow, action, allDone } */
    Map<String, Object> getActionState(String work_order_id);

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
