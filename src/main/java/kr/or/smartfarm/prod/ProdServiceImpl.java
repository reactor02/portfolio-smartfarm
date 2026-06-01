package kr.or.smartfarm.prod;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.smartfarm.work.WorkDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 생산계획(Production Plan) 서비스 구현체
 *
 * - ProdService 인터페이스를 구현한다.
 * - 비즈니스 로직(페이징 계산, 상태 동기화 등)을 처리하고 DAO 를 호출한다.
 * - @Service 애노테이션으로 스프링 컨텍스트에 빈으로 등록된다.
 */
@Service
public class ProdServiceImpl implements ProdService {

    // 생산계획 DAO 의존성 주입
    @Autowired
    private ProdDAO dao;

    /**
     * 생산계획 목록 조회 (페이징 + 검색 조건 적용)
     *
     * - 호출 전 syncPlanStatus() 를 통해 plan_start 가 지난 "대기" 상태 계획을 "진행"으로 일괄 갱신한다.
     * - 페이지 번호로 startRow / endRow 를 계산해 ProdPageDTO 에 세팅 후 DAO 에 전달한다.
     * - 조회 결과의 첫 행에 담긴 total_count 를 이용해 전체 페이지 수, 페이지 블록을 계산한다.
     *
     * @param page  검색 조건 및 페이지 정보 DTO
     * @return 조회된 생산계획 목록
     */
    @Override
    public List<ProdDTO> getList(ProdPageDTO page) {
        // 행 번호 범위 계산 (Oracle ROWNUM 기반 페이징에 사용)
        int startRow = (page.getPage() - 1) * page.getSize() + 1;
        int endRow   =  page.getPage()      * page.getSize();
        page.setStartRow(startRow);
        page.setEndRow(endRow);

        // plan_start 가 지난 "대기" 계획을 "진행"으로 일괄 업데이트
        dao.syncPlanStatus();           // 대기 → 진행
        dao.syncCompletePlanStatus();   // 진행/대기 → 완료 (SUM(current_qty) >= plan_qty 달성 시)
        List<ProdDTO> list = dao.getList(page);

        // 전체 건수를 기반으로 페이지 메타 정보 계산
        if (list != null && !list.isEmpty()) {
            int totalCount = list.get(0).getTotal_count();
            int totalPages = (int) Math.ceil((double) totalCount / page.getSize());
            // 현재 페이지가 속한 블록의 시작/끝 페이지 계산 (예: blockSize=10 이면 1~10, 11~20 단위)
            int startPage  = (((page.getPage() - 1) / page.getBlockSize()) * page.getBlockSize()) + 1;
            int endPage    = Math.min(startPage + page.getBlockSize() - 1, totalPages);

            page.setTotalCount(totalCount);
            page.setTotalPages(totalPages);
            page.setStartPage(startPage);
            page.setEndPage(endPage);
        }
        return list;
    }

    /**
     * 담당자(사원) 드롭다운 옵션 목록 조회
     *
     * @return SelectOptionDTO 목록 (num=emp_num, name=ename)
     */
    @Override
    public List<SelectOptionDTO> getEmpList() {
        return dao.getEmpList();
    }

    /**
     * 시설(설비) 드롭다운 옵션 목록 조회
     *
     * @return SelectOptionDTO 목록 (num=facility_num, name=facility_name)
     */
    @Override
    public List<SelectOptionDTO> getFacilityOptions() {
        return dao.getFacilityOptions();
    }

    /**
     * 품목 드롭다운 옵션 목록 조회 (PRODUCT, SEMIPRODUCT 만)
     *
     * @return SelectOptionDTO 목록 (num=item_num, name=item 이름, type=품목 유형)
     */
    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return dao.getItemOptions();
    }

    /**
     * 생산계획 단건 조회
     *
     * @param plan_id  조회할 생산계획 식별자
     * @return 해당 생산계획 DTO, 없으면 null
     */
    @Override
    public ProdDTO selectOne(String plan_id) {
        return dao.getSelectOne(plan_id);
    }

    /**
     * 생산계획 신규 등록
     *
     * @param prodDTO  등록할 생산계획 데이터
     * @return 영향받은 행 수
     */
    @Override
    public int create(ProdDTO prodDTO) {
        return dao.create(prodDTO);
    }

    /**
     * 생산계획 상태 변경
     *
     * - ProdDTO 에 plan_id 와 변경할 상태를 담아 DAO 에 전달한다.
     *
     * @param plan_id  상태를 변경할 생산계획 식별자
     * @param status   변경할 상태값 (예: "취소")
     */
    @Override
    public void updateStatus(String plan_id, String status) {
        ProdDTO dto = new ProdDTO();
        dto.setPlan_id(plan_id);
        dto.setPlan_status(status);
        dao.updateStatus(dto);
    }

    /**
     * 특정 생산계획에 속한 작업지시 목록 조회 (페이징)
     *
     * - 한 페이지당 5건을 기준으로 startRow / endRow 를 계산한다.
     * - 결과로 list, totalPages, totalCount, currentPage 를 Map 에 담아 반환한다.
     *
     * @param plan_num  생산계획 일련번호 (PK)
     * @param page      조회 페이지 번호
     * @return 작업지시 목록 및 페이징 정보가 담긴 Map
     */
    @Override
    public Map<String, Object> getWorkOrders(int plan_num, int page) {
        int size     = 5; // 작업지시 목록 한 페이지 표시 건수
        int startRow = (page - 1) * size + 1;
        int endRow   =  page      * size;

        // DAO 에 전달할 파라미터 맵 구성
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("plan_num", plan_num);
        params.put("startRow", startRow);
        params.put("endRow",   endRow);

        List<WorkDTO> list = dao.getWorkOrders(params);

        // 전체 건수 및 총 페이지 수 계산 (결과가 없으면 0)
        int totalCount = (list != null && !list.isEmpty()) ? list.get(0).getTotal_count() : 0;
        int totalPages = totalCount > 0 ? (int) Math.ceil((double) totalCount / size) : 0;

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("list",        list);
        result.put("totalPages",  totalPages);
        result.put("totalCount",  totalCount);
        result.put("currentPage", page);
        return result;
    }

    /** 생산계획 담당자 emp_num 조회 (취소 권한 검증용) */
    @Override
    public String getEmpNum(String plan_id) {
        return dao.getEmpNum(plan_id);
    }
}
