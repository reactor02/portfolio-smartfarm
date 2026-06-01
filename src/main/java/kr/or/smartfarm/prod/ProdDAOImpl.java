package kr.or.smartfarm.prod;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.work.WorkDTO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * 생산계획(Production Plan) DAO 구현체
 *
 * - ProdDAO 인터페이스를 구현한다.
 * - MyBatis 의 SqlSession 을 통해 prod.xml 에 정의된 SQL 구문을 실행한다.
 * - @Repository 애노테이션으로 스프링 컨텍스트에 빈으로 등록된다.
 * - SQL ID 의 네임스페이스는 "kr.or.smartfarm.prod" 를 사용한다.
 */
@Repository
public class ProdDAOImpl implements ProdDAO {

    // MyBatis SqlSession 의존성 주입 (SQL 실행에 사용)
    @Autowired
    private SqlSession session;

    /**
     * 생산계획 목록 조회 (페이징 + 검색)
     * - SQL ID: kr.or.smartfarm.prod.getList
     */
    @Override
    public List<ProdDTO> getList(ProdPageDTO page) {
        return session.selectList("kr.or.smartfarm.prod.getList", page);
    }

    /**
     * 담당자(사원) 드롭다운 옵션 목록 조회
     * - SQL ID: kr.or.smartfarm.prod.getEmpList
     */
    @Override
    public List<SelectOptionDTO> getEmpList() {
        return session.selectList("kr.or.smartfarm.prod.getEmpList");
    }

    /**
     * 시설(설비) 드롭다운 옵션 목록 조회
     * - SQL ID: kr.or.smartfarm.prod.getFacilityOptions
     */
    @Override
    public List<SelectOptionDTO> getFacilityOptions() {
        return session.selectList("kr.or.smartfarm.prod.getFacilityOptions");
    }

    /**
     * 품목 드롭다운 옵션 목록 조회
     * - SQL ID: kr.or.smartfarm.prod.getItemOptions
     */
    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.prod.getItemOptions");
    }

    /**
     * 생산계획 단건 조회
     * - SQL ID: kr.or.smartfarm.prod.getOne
     *
     * @param plan_id  조회할 생산계획 식별자
     */
    @Override
    public ProdDTO getSelectOne(String plan_id) {
        return session.selectOne("kr.or.smartfarm.prod.getOne", plan_id);
    }

    /**
     * 생산계획 신규 등록
     * - SQL ID: kr.or.smartfarm.prod.insert
     * - selectKey 를 통해 plan_id 가 자동 생성되어 prodDTO 에 채워진다.
     */
    @Override
    public int create(ProdDTO prodDTO) {
        return session.insert("kr.or.smartfarm.prod.insert", prodDTO);
    }

    /**
     * 생산계획 상태 변경
     * - SQL ID: kr.or.smartfarm.prod.updateStatus
     */
    @Override
    public int updateStatus(ProdDTO prodDTO) {
        return session.update("kr.or.smartfarm.prod.updateStatus", prodDTO);
    }

    /**
     * "대기" 상태 계획을 "진행"으로 일괄 업데이트 (날짜 동기화)
     * - SQL ID: kr.or.smartfarm.prod.syncPlanStatus
     */
    @Override
    public int syncPlanStatus() {
        return session.update("kr.or.smartfarm.prod.syncPlanStatus");
    }

    /**
     * SUM(current_qty) >= plan_qty 달성 계획을 "완료"로 일괄 업데이트
     * - SQL ID: kr.or.smartfarm.prod.syncCompletePlanStatus
     */
    @Override
    public int syncCompletePlanStatus() {
        return session.update("kr.or.smartfarm.prod.syncCompletePlanStatus");
    }

    /**
     * 특정 생산계획에 속한 작업지시 목록 조회 (페이징)
     * - SQL ID: kr.or.smartfarm.prod.getWorkOrders
     *
     * @param params  plan_num, startRow, endRow 를 담은 파라미터 Map
     */
    @Override
    public List<WorkDTO> getWorkOrders(Map<String, Object> params) {
        return session.selectList("kr.or.smartfarm.prod.getWorkOrders", params);
    }

    /** 생산계획 담당자 emp_num 조회 (취소 권한 검증용) */
    @Override
    public String getEmpNum(String plan_id) {
        return session.selectOne("kr.or.smartfarm.prod.getEmpNum", plan_id);
    }
}
