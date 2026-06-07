package kr.or.smartfarm.work;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import static org.mockito.BDDMockito.given;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import kr.or.smartfarm.lot.LotDAO;
import kr.or.smartfarm.lot.LotRelationDAO;
import kr.or.smartfarm.lot.LotRelationDTO;
import kr.or.smartfarm.prod.ProdDAO;

/**
 * 작업지시 회차(Cycle) 반복 생산 BDD 단위 테스트.
 *
 * <p>정상 경로뿐 아니라 <b>실패해야 하는 상황</b>(NULL/경계값/중복제출/수량부족 등)을
 * 명세로 박아 회귀를 방어한다. 모든 DAO는 Mockito mock (DB 불필요).</p>
 */
@RunWith(MockitoJUnitRunner.class)
public class WorkCycleServiceTest {

    @Mock private WorkDAO        dao;
    @Mock private LotDAO         lotDao;
    @Mock private LotRelationDAO lotRelationDao;
    @Mock private ProdDAO        prodDao;

    @InjectMocks private WorkServiceImpl service;

    /* ── 헬퍼 ── */
    private WorkDTO work(String id, String status, int orderNum, int itemNum,
                         int orderQty, int currentQty, int inputQty, Integer productLot) {
        WorkDTO w = new WorkDTO();
        w.setWork_order_id(id);
        w.setWork_status(status);
        w.setOrder_num(orderNum);
        w.setItem_num(itemNum);
        w.setOrder_qty(orderQty);
        w.setCurrent_qty(currentQty);
        w.setInput_qty(inputQty);
        w.setProduct_lot_num(productLot);
        w.setType("PRODUCT");
        w.setPlan_num(5);
        return w;
    }

    private Map<String, Object> wp(int wpNum, int processNum, int flow, String status) {
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("WORK_PROCESS_NUM", wpNum);
        m.put("PROCESS_NUM",      processNum);
        m.put("FLOW",             flow);
        m.put("STATUS",           status);
        return m;
    }

    private Map<String, Object> proc(int processNum, int flow) {
        Map<String, Object> m = new HashMap<String, Object>();
        m.put("PROCESS_NUM", processNum);
        m.put("FLOW",        flow);
        return m;
    }

    private List<Map<String, Object>> allDoneProcesses() {
        return Arrays.asList(wp(1, 501, 1, "완료"), wp(2, 502, 2, "완료"), wp(3, 503, 3, "완료"));
    }

    /* ════════════ 1·2. getActionState 의 다음회차 노출 신호 ════════════ */

    @Test
    public void allDone이고_지시수량_미달이면_canNextCycle이_true다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 40, 0, 777));
        given(dao.getWorkProcesses(10)).willReturn(allDoneProcesses());
        given(dao.getCurrentCycleNo(10)).willReturn(1);

        Map<String, Object> st = service.getActionState("WO");

        assertEquals(Boolean.TRUE, st.get("allDone"));
        assertEquals("done",       st.get("action"));
        assertEquals(Boolean.TRUE, st.get("canNextCycle"));
    }

    @Test
    public void 지시수량을_채웠으면_canNextCycle은_false다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 100, 0, 777));
        given(dao.getWorkProcesses(10)).willReturn(allDoneProcesses());

        Map<String, Object> st = service.getActionState("WO");

        assertEquals(Boolean.TRUE,  st.get("allDone"));
        assertEquals(Boolean.FALSE, st.get("canNextCycle"));
    }

    /* ════════════ 3. 다음회차 시작 — 새 회차 공정 생성 + input_qty 리셋 ════════════ */

    @Test
    public void 다음회차_시작은_새cycle_공정행을_생성하고_input_qty를_리셋한다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 40, 40, 777));
        given(dao.getWorkProcesses(10)).willReturn(allDoneProcesses());   // 현재 회차 전부 완료
        given(dao.getCurrentCycleNo(10)).willReturn(1);
        given(dao.getProcessesByItem(9002)).willReturn(Arrays.asList(proc(501, 1), proc(502, 2), proc(503, 3)));

        service.startNextCycle("WO");

        // 공정 수(3)만큼 새 행 생성, cycle_no=2 로
        ArgumentCaptor<Map<String, Object>> cap = ArgumentCaptor.forClass(Map.class);
        verify(dao, times(3)).insertWorkProcess(cap.capture());
        for (Map<String, Object> row : cap.getAllValues()) {
            assertEquals(2, row.get("cycle_no"));
        }
        verify(dao).resetInputQty(anyMap());
    }

    /* ════════════ 4·10. 게이트 — 실패해야 하는 상황 ════════════ */

    @Test
    public void 진행상태가_아니면_다음회차_불가하고_아무것도_만들지_않는다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "대기", 10, 9002, 100, 40, 0, 777));
        assertStateError(() -> service.startNextCycle("WO"));
        verify(dao, never()).insertWorkProcess(anyMap());
        verify(dao, never()).resetInputQty(anyMap());
    }

    @Test
    public void 현재회차가_아직_진행중이면_다음회차를_또_시작하지_못한다() {
        // [중복제출/레이스] '다음 회차' 연타 — 활성 공정이 남아있으면 새 cycle 생성 금지
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 40, 40, 777));
        given(dao.getWorkProcesses(10)).willReturn(Arrays.asList(
            wp(1, 501, 1, "완료"), wp(2, 502, 2, "진행"), wp(3, 503, 3, "대기")));

        assertStateError(() -> service.startNextCycle("WO"));
        verify(dao, never()).insertWorkProcess(anyMap());
        verify(dao, never()).resetInputQty(anyMap());
    }

    @Test
    public void 지시수량을_이미_채웠으면_다음회차_불가() {
        // [경계값] current == order → 다음 회차 없음
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 100, 50, 777));
        given(dao.getWorkProcesses(10)).willReturn(allDoneProcesses());

        assertStateError(() -> service.startNextCycle("WO"));
        verify(dao, never()).insertWorkProcess(anyMap());
    }

    @Test
    public void 지시수량보다_딱_하나_모자라면_다음회차_가능() {
        // [경계값/off-by-one] current == order-1 → 허용 (> vs >= 경계 방어)
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 99, 99, 777));
        given(dao.getWorkProcesses(10)).willReturn(allDoneProcesses());
        given(dao.getCurrentCycleNo(10)).willReturn(1);
        given(dao.getProcessesByItem(9002)).willReturn(Arrays.asList(proc(501, 1)));

        service.startNextCycle("WO");

        verify(dao, times(1)).insertWorkProcess(anyMap());
        verify(dao).resetInputQty(anyMap());
    }

    /* ════════════ 8. NULL/존재안함 방어 ════════════ */

    @Test(expected = IllegalArgumentException.class)
    public void 다음회차_작업번호가_null이면_예외() {
        service.startNextCycle(null);
    }

    @Test(expected = IllegalArgumentException.class)
    public void 다음회차_없는_작업지시면_예외() {
        given(dao.getSelectOne("NOPE")).willReturn(null);
        service.startNextCycle("NOPE");
    }

    /* ════════════ 5·6. 회차 최종완료 — 누적 + 현재회차 자재만 계보 연결 ════════════ */

    @Test
    public void 회차_최종완료는_완제품LOT을_누적확정하고_현재회차_자재만_계보연결한다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 40, 60, 777));
        given(dao.getWorkProcesses(10)).willReturn(Arrays.asList(
            wp(1, 501, 1, "완료"), wp(2, 502, 2, "완료"), wp(3, 503, 3, "진행")));
        // 현재 회차에 투입된 자재 LOT (이전 회차 자재는 포함되지 않아야 함)
        given(dao.getCurrentCycleProcessLots(10)).willReturn(Arrays.asList(new HashMap<String, Object>() {{
            put("LOT_NUM", 950);
        }}));

        service.completeProcess("WO", 503);

        // 누적형 finalize + current_qty 반영
        verify(dao).finalizeProductLot(anyMap());
        verify(dao).setCurrentQty(anyMap());
        verify(dao).insertProduceIo(anyMap());
        // 계보는 현재 회차 자재(950)로만 연결, 전체조회(getWorkProcessLots)는 쓰지 않는다
        verify(dao).getCurrentCycleProcessLots(10);
        verify(dao, never()).getWorkProcessLots(10);
        ArgumentCaptor<LotRelationDTO> cap = ArgumentCaptor.forClass(LotRelationDTO.class);
        verify(lotRelationDao).insert(cap.capture());
        assertEquals(950, cap.getValue().getChild_lot_num());
        assertEquals(777, cap.getValue().getParent_lot_num());
    }

    /* ── util ── */
    private interface Run { void run(); }
    private void assertStateError(Run r) {
        try { r.run(); fail("state_error 예외가 발생해야 한다"); }
        catch (RuntimeException e) { assertEquals("state_error", e.getMessage()); }
    }
}
