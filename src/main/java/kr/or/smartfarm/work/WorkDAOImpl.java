package kr.or.smartfarm.work;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.bom.BomDTO;
import kr.or.smartfarm.prod.ProdDTO;
import kr.or.smartfarm.prod.SelectOptionDTO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * 작업지시(WorkOrder) DAO 구현체.
 *
 * <p>MyBatis {@link SqlSession}을 직접 사용하여 work.xml(및 일부 공용 매퍼)의
 * 네임스페이스 {@code kr.or.smartfarm.work.*} statement를 호출한다.
 * 비즈니스 로직은 {@link WorkServiceImpl}에 있고, 이 클래스는 SQL 매핑 호출만 담당한다.</p>
 */
@Repository
public class WorkDAOImpl implements WorkDAO {

    /** MyBatis SQL 실행 세션 (스프링이 주입) */
    @Autowired
    private SqlSession session;

    /** 작업지시 목록 조회 (ROWNUM 페이징 파라미터 포함, total_count 동반 반환) */
    @Override
    public List<WorkDTO> getList(WorkPageDTO page) {
        return session.selectList("kr.or.smartfarm.work.getList", page);
    }

    /** work_order_id로 작업지시 단건 상세 조회 */
    @Override
    public WorkDTO getSelectOne(String work_order_id) {
        return session.selectOne("kr.or.smartfarm.work.getOne", work_order_id);
    }

    /** 작업지시 신규 등록 (selectKey로 work_order_id 채번) */
    @Override
    public int create(WorkDTO workDTO) {
        return session.insert("kr.or.smartfarm.work.insert", workDTO);
    }

    /** 작업지시 상태 변경 (대기/진행/완료/취소) */
    @Override
    public int updateStatus(WorkDTO workDTO) {
        return session.update("kr.or.smartfarm.work.updateStatus", workDTO);
    }

    /** 생산 완료 처리 — 작업지시 상태를 '완료'로 갱신 */
    @Override
    public int produce(WorkDTO workDTO) {
        return session.update("kr.or.smartfarm.work.produce", workDTO);
    }

    /** 해당 생산계획의 작업지시가 모두 끝났으면 plan_status도 '완료'로 동기화 */
    @Override
    public int completePlanIfDone(String work_order_id) {
        return session.update("kr.or.smartfarm.work.completePlanIfDone", work_order_id);
    }

    /** 등록 모달 담당자 드롭다운 옵션 */
    @Override
    public List<SelectOptionDTO> getEmpOptions() {
        return session.selectList("kr.or.smartfarm.work.getEmpOptions");
    }

    /** 등록 모달 생산계획 드롭다운 옵션 */
    @Override
    public List<SelectOptionDTO> getPlanOptions() {
        return session.selectList("kr.or.smartfarm.work.getPlanOptions");
    }

    /** 등록 모달 품목 드롭다운 옵션 */
    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.work.getItemOptions");
    }

    /** 생산계획 검색 (작업지시 등록 시 계획 선택용, 페이징) */
    @Override
    public List<ProdDTO> searchPlans(Map<String, Object> params) {
        return session.selectList("kr.or.smartfarm.work.searchPlans", params);
    }

    /** 품목의 BOM(소요 자재) 목록 조회 — 생산 시 자재 차감 기준 */
    @Override
    public List<BomDTO> getMaterialsByItem(int item_num) {
        return session.selectList("kr.or.smartfarm.work.getMaterialsByItem", item_num);
    }

    /** 자재 입출고(io) 이력 기록 — 생산투입 출고 등 */
    @Override
    public void insertIo(Map<String, Object> params) {
        session.insert("kr.or.smartfarm.work.insertIo", params);
    }
}
