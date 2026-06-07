package kr.or.smartfarm.work;

import static org.junit.Assert.*;
import static org.mockito.BDDMockito.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import kr.or.smartfarm.bom.BomDTO;
import kr.or.smartfarm.lot.LotDAO;
import kr.or.smartfarm.lot.LotDTO;
import kr.or.smartfarm.lot.LotRelationDAO;
import kr.or.smartfarm.lot.LotRelationDTO;
import kr.or.smartfarm.prod.ProdDAO;

/**
 * 작업지시 공정별(라우팅) 상태머신 BDD 단위 테스트.
 * given/when/then 스타일, 모든 DAO는 Mockito mock (DB 불필요).
 */
@RunWith(MockitoJUnitRunner.class)
public class WorkProcessServiceTest {

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

    private BomDTO bom(int item2, int req, String name) {
        BomDTO b = new BomDTO();
        b.setItem_num2(item2);
        b.setRequired_qty(req);
        b.setName(name);
        b.setCode("C" + item2);
        return b;
    }

    private LotDTO lot(int lotNum, int cur, int qc) {
        LotDTO l = new LotDTO();
        l.setLot_num(lotNum);
        l.setCurrent_qty(cur);
        l.setQc_num(qc);
        return l;
    }

    /* ── 1. NULL 방어 ── */
    @Test(expected = IllegalArgumentException.class)
    public void 작업번호가_NULL이면_예외() {
        service.inputProcessMaterial(null, 1, 1);
    }

    /* ── 2. ensureWorkProcesses 멱등 ── */
    @Test
    public void 공정기록이_없으면_공정수만큼_생성한다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "대기", 10, 9002, 100, 0, 0, null));
        given(dao.countWorkProcesses(10)).willReturn(0);
        given(dao.getProcessesByItem(9002)).willReturn(new ArrayList<Map<String, Object>>() {{
            add(proc(501, 1)); add(proc(502, 2)); add(proc(503, 3));
        }});

        service.ensureWorkProcesses("WO");

        verify(dao, times(3)).insertWorkProcess(anyMap());
    }

    @Test
    public void 공정기록이_이미_있으면_생성하지_않는다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "대기", 10, 9002, 100, 0, 0, null));
        given(dao.countWorkProcesses(10)).willReturn(3);

        service.ensureWorkProcesses("WO");

        verify(dao, never()).insertWorkProcess(anyMap());
    }

    /* ── 3. 작업시작 시 완제품 LOT 생성 ── */
    @Test
    public void 작업시작시_완제품LOT을_생성하고_참조를_저장한다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "대기", 10, 9002, 100, 0, 0, null));

        service.start("WO");

        verify(dao).updateStatus(any(WorkDTO.class));
        verify(dao).insertProductLotStart(anyMap());
        verify(dao).setProductLotNum(anyMap());
    }

    /* ── 4. 최대생산량 계산 ── */
    @Test
    public void 최대생산량은_자재별_가용재고_최솟값이며_지시수량으로_cap된다() {
        // 자재A req2 가용150 → 75, 자재B req1 가용100 → 100, 지시수량 100 → min=75
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));
        List<BomDTO> mats = new ArrayList<BomDTO>();
        mats.add(bom(1361, 2, "배지")); mats.add(bom(1241, 1, "배양병"));
        given(dao.getBomMaterialsDetail(9002)).willReturn(mats);
        given(lotDao.getQcPassedLotsFIFO(1361)).willReturn(java.util.Arrays.asList(lot(900, 150, 1)));
        given(lotDao.getQcPassedLotsFIFO(1241)).willReturn(java.util.Arrays.asList(lot(901, 100, 1)));

        Map<String, Object> info = service.getMaxInfo("WO");

        assertEquals(75, ((Number) info.get("maxProducible")).intValue());
    }

    /* ── 5. 소모자재 투입(첫, 적정수량) → 통과 ── */
    @Test
    public void 첫_소모자재투입은_배치수량을_확정하고_FIFO차감한다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(
            wp(1, 501, 1, "대기"), wp(2, 502, 2, "대기"), wp(3, 503, 3, "대기")));
        // maxProducible 계산용 (배지 req2 가용100 → 50)
        given(dao.getBomMaterialsDetail(9002)).willReturn(java.util.Arrays.asList(bom(1361, 2, "배지")));
        given(lotDao.getQcPassedLotsFIFO(1361)).willReturn(java.util.Arrays.asList(lot(900, 100, 5)));
        // 공정 501 소모자재
        given(dao.getProcessMaterials(501)).willReturn(java.util.Arrays.asList(bom(1361, 2, "배지")));

        service.inputProcessMaterial("WO", 501, 10);   // 10 ≤ 50

        verify(dao).setInputQty(anyMap());                 // 배치수량 확정
        verify(lotDao).deductQty(900, 20);                 // req2 × 10
        verify(dao).insertWorkProcessLot(anyMap());        // 소모 LOT 기록
        ArgumentCaptor<Map> cap = ArgumentCaptor.forClass(Map.class);
        verify(dao).setWorkProcessStatus(cap.capture());
        assertEquals("자재투입", cap.getValue().get("status"));
    }

    /* ── 6. 소모자재 투입(초과) → qty_error, 차감/상태변경 없음 ── */
    @Test
    public void 투입수량이_최대생산량을_초과하면_거부하고_아무것도_바꾸지_않는다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(
            wp(1, 501, 1, "대기")));
        given(dao.getBomMaterialsDetail(9002)).willReturn(java.util.Arrays.asList(bom(1361, 2, "배지")));
        given(lotDao.getQcPassedLotsFIFO(1361)).willReturn(java.util.Arrays.asList(lot(900, 100, 5))); // max 50

        try {
            service.inputProcessMaterial("WO", 501, 999);   // 999 > 50
            fail("qty_error 예외가 발생해야 한다");
        } catch (RuntimeException e) {
            assertEquals("qty_error", e.getMessage());
        }
        verify(dao, never()).setInputQty(anyMap());
        verify(lotDao, never()).deductQty(anyInt(), anyInt());
        verify(dao, never()).setWorkProcessStatus(anyMap());
    }

    /* ── 7. 상태 게이팅 ── */
    @Test
    public void 작업이_진행상태가_아니면_소모자재투입_불가() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "대기", 10, 9002, 100, 0, 0, null));
        assertStateError(() -> service.inputProcessMaterial("WO", 501, 10));
    }

    @Test
    public void 활성공정이_아닌_공정에_투입하면_state_error() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "대기")));
        assertStateError(() -> service.inputProcessMaterial("WO", 502, 10));
    }

    @Test
    public void 자재투입_전에_공정시작하면_state_error() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "대기")));
        assertStateError(() -> service.startProcess("WO", 501));
    }

    @Test
    public void 진행_전에_공정완료하면_state_error() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "자재투입")));
        assertStateError(() -> service.completeProcess("WO", 501));
    }

    /* ── 8. 공정 완료: 중간/최종 ── */
    @Test
    public void 중간공정_완료는_완제품LOT을_확정하지_않는다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 10, 777));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(
            wp(1, 501, 1, "진행"), wp(2, 502, 2, "대기"), wp(3, 503, 3, "대기")));

        service.completeProcess("WO", 501);

        verify(dao).setWorkProcessStatus(anyMap());
        verify(dao, never()).finalizeProductLot(anyMap());
        verify(dao, never()).setCurrentQty(anyMap());
    }

    @Test
    public void 최종공정_완료는_완제품LOT확정_생산입고_생산완료수량반영() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 10, 777));
        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(
            wp(1, 501, 1, "완료"), wp(2, 502, 2, "완료"), wp(3, 503, 3, "진행")));
        // 계보 연결은 현재 회차 자재만 사용 (getCurrentCycleProcessLots)
        given(dao.getCurrentCycleProcessLots(10)).willReturn(java.util.Arrays.asList(new HashMap<String, Object>() {{
            put("LOT_NUM", 900);
        }}));

        service.completeProcess("WO", 503);

        verify(dao).finalizeProductLot(anyMap());
        verify(dao).insertProduceIo(anyMap());
        verify(dao).setCurrentQty(anyMap());
        verify(lotRelationDao).insert(any(LotRelationDTO.class));
    }

    /* ── 9. 작업완료 분기 ── */
    @Test
    public void 진행중_공정이_있으면_작업완료_불가() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 50, 50, 777));
        given(dao.countActiveProcess(10)).willReturn(1);

        assertEquals("in_progress", service.completeWork("WO", false));
        verify(dao, never()).setWorkStatus(anyMap());
    }

    @Test
    public void 지시수량만큼_생산했으면_즉시_완료() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 100, 100, 777));
        given(dao.countActiveProcess(10)).willReturn(0);

        assertEquals("ok", service.completeWork("WO", false));
        verify(dao).setWorkStatus(anyMap());
    }

    @Test
    public void 미달이면_force없이는_not_full_force면_완료() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 30, 30, 777));
        given(dao.countActiveProcess(10)).willReturn(0);

        assertEquals("not_full", service.completeWork("WO", false));
        verify(dao, never()).setWorkStatus(anyMap());

        assertEquals("ok", service.completeWork("WO", true));
        verify(dao).setWorkStatus(anyMap());
    }

    /* ── 10. 액션 상태(버튼 노출용) ── */
    @Test
    public void 액션상태는_활성공정의_상태에_따라_결정된다() {
        given(dao.getSelectOne("WO")).willReturn(work("WO", "진행", 10, 9002, 100, 0, 0, null));

        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "대기")));
        assertEquals("input", service.getActionState("WO").get("action"));

        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "자재투입")));
        assertEquals("start", service.getActionState("WO").get("action"));

        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "진행")));
        assertEquals("complete", service.getActionState("WO").get("action"));

        given(dao.getWorkProcesses(10)).willReturn(java.util.Arrays.asList(wp(1, 501, 1, "완료")));
        Map<String, Object> done = service.getActionState("WO");
        assertEquals("done", done.get("action"));
        assertEquals(Boolean.TRUE, done.get("allDone"));
    }

    /* ── util ── */
    private interface Run { void run(); }
    private void assertStateError(Run r) {
        try { r.run(); fail("state_error 예외가 발생해야 한다"); }
        catch (RuntimeException e) { assertEquals("state_error", e.getMessage()); }
    }
}
