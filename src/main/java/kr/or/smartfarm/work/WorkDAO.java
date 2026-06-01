package kr.or.smartfarm.work;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.bom.BomDTO;
import kr.or.smartfarm.prod.ProdDTO;
import kr.or.smartfarm.prod.SelectOptionDTO;

/**
 * WorkDAO - 작업지시(Work Order) DB 접근 인터페이스.
 *
 * MyBatis SqlSession을 통해 order.xml 매퍼의 SQL을 실행한다.
 * 실제 구현은 WorkDAOImpl이 담당하며, namespace는 "kr.or.smartfarm.work" 이다.
 */
public interface WorkDAO {

    /**
     * 작업지시 목록을 페이징·필터 조건으로 조회한다.
     * SQL: kr.or.smartfarm.work.getList
     *
     * @param page 페이징 범위(startRow, endRow) 및 검색 필터가 담긴 DTO
     * @return 작업지시 목록 (total_count 포함)
     */
    List<WorkDTO> getList(WorkPageDTO page);

    /**
     * 특정 작업지시 단건을 조회한다.
     * SQL: kr.or.smartfarm.work.getOne
     *
     * @param work_order_id 조회할 작업지시 ID
     * @return 작업지시 상세 DTO (연관 테이블 JOIN 포함), 없으면 null
     */
    WorkDTO getSelectOne(String work_order_id);

    /**
     * 새 작업지시를 INSERT 한다.
     * SQL: kr.or.smartfarm.work.insert
     * selectKey를 통해 work_order_id(plan_id + 순번)가 자동 생성된다.
     * 생산계획이 취소/완료/기간 초과인 경우 INSERT가 실행되지 않는다.
     *
     * @param workDTO 등록할 작업지시 정보
     * @return INSERT 행 수 (1: 성공, 0: 조건 미충족)
     */
    int create(WorkDTO workDTO);

    /**
     * 작업지시의 상태(order_status)를 변경한다.
     * SQL: kr.or.smartfarm.work.updateStatus
     * 완료·취소 상태에서는 변경이 차단된다.
     *
     * @param workDTO work_order_id와 변경할 work_status가 담긴 DTO
     * @return UPDATE 행 수
     */
    int updateStatus(WorkDTO workDTO);

    /**
     * 생산실적 처리: current_qty = order_qty, order_end = SYSDATE, order_status = '완료' 로 갱신.
     * SQL: kr.or.smartfarm.work.produce
     * 이미 완료·취소 상태이면 UPDATE가 무시된다.
     *
     * @param workDTO work_order_id가 담긴 DTO
     * @return UPDATE 행 수
     */
    int produce(WorkDTO workDTO);

    /**
     * 작업 완료 후 생산계획의 완료 여부를 검사하여 완료 처리한다.
     * SQL: kr.or.smartfarm.work.completePlanIfDone
     * SUM(current_qty) >= plan_qty 이면 해당 production_plan의 상태를 '완료'로 변경한다.
     *
     * @param work_order_id 방금 완료된 작업지시 ID (plan_num 조회에 사용)
     * @return UPDATE 행 수 (0: 아직 미완료, 1: 계획 완료 처리됨)
     */
    int completePlanIfDone(String work_order_id);

    /**
     * 담당자 선택 옵션 목록을 반환한다.
     * SQL: kr.or.smartfarm.work.getEmpOptions
     *
     * @return 담당자 목록 (num: emp_num, name: ename)
     */
    List<SelectOptionDTO> getEmpOptions();

    /**
     * 실무자 선택 옵션 목록을 반환한다. (e_level=1, 재직자만)
     * SQL: kr.or.smartfarm.work.getWorkerOptions
     *
     * @return 실무자 목록 (num: emp_num, name: ename)
     */
    List<SelectOptionDTO> getWorkerOptions();

    /**
     * 생산계획 선택 옵션 목록을 반환한다. (취소 제외)
     * SQL: kr.or.smartfarm.work.getPlanOptions
     *
     * @return 생산계획 목록 (num: plan_num, name: plan_id)
     */
    List<SelectOptionDTO> getPlanOptions();

    /**
     * 품목 선택 옵션 목록을 반환한다. (PRODUCT + SEMIPRODUCT)
     * SQL: kr.or.smartfarm.work.getItemOptions
     *
     * @return 품목 목록 (num: item_num, name: item_name, type: item_type)
     */
    List<SelectOptionDTO> getItemOptions();

    /**
     * 등록 모달 AJAX 검색용 생산계획 목록을 조회한다. (취소·완료 제외, 페이징 적용)
     * SQL: kr.or.smartfarm.work.searchPlans
     *
     * @param params Map { keyword, startRow, endRow }
     * @return 생산계획 목록 (total_count 포함)
     */
    List<ProdDTO> searchPlans(Map<String, Object> params);

    /**
     * 완성품 item_num을 기준으로 BOM(Bill of Materials) 재료 목록을 조회한다.
     * SQL: kr.or.smartfarm.work.getMaterialsByItem
     * bom_status = 'Y' (유효한 BOM 항목만 조회)
     *
     * @param item_num 완성품 또는 반제품의 item_num
     * @return BOM 재료 목록 (item_num2: 재료 품목 번호, required_qty: 단위당 소요량)
     */
    List<BomDTO> getMaterialsByItem(int item_num);

    /**
     * 재료 출고 내역을 io 테이블에 INSERT 한다.
     * SQL: kr.or.smartfarm.work.insertIo
     *
     * @param params Map { ioType, ioQty, qcNum, lotNum, planNum, ioReason }
     *               - ioType: 입출고 구분 (생산투입 시 "출고")
     *               - ioQty: 출고 수량
     *               - qcNum: 해당 LOT의 QC 번호
     *               - lotNum: 차감 대상 LOT 번호
     *               - planNum: 연관 생산계획 번호
     *               - ioReason: 출고 사유 (예: "생산투입")
     */
    void insertIo(Map<String, Object> params);

    /** 품목별 공정 목록 조회 (작업순서 오름차순, 작업지시 상세 페이지용) */
    List<Map<String, Object>> getProcessesByItem(int item_num);

    /**
     * 작업지시 담당자 emp_num 조회 (취소/완료 권한 검증용)
     *
     * @param work_order_id 작업지시 ID
     * @return 담당자 emp_num 문자열, 없으면 null
     */
    String getEmpNum(String work_order_id);
}
