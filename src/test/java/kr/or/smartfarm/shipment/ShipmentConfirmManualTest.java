package kr.or.smartfarm.shipment;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

/**
 * 출하확정(수동 LOT 선택) 로직 검증 — {@link ShipmentServiceImpl#confirmShipmentManual}.
 *
 * <p>DB 없이 {@link ShipmentDAO}를 mock 으로 주입하고, 검증 순서/분할 경로/방어로직을
 * 상호작용(verify)으로 확인한다. 사용자가 상세 페이지에서 고른 {lot_num, qty} 선택과
 * force(부분출하 허용) 플래그에 따른 동작을 검증한다.</p>
 */
@RunWith(MockitoJUnitRunner.class)
public class ShipmentConfirmManualTest {

    @Mock
    private ShipmentDAO shipmentDAO;

    @InjectMocks
    private ShipmentServiceImpl service;

    /** {lot_num, qty} 선택 한 건 */
    private Map sel(int lotNum, int qty) {
        Map m = new HashMap();
        m.put("lot_num", lotNum);
        m.put("qty", qty);
        return m;
    }

    /** selectLotForConfirm 가 돌려줄 LOT 행(hashMap, 대문자 키) */
    private Map lotRow(int currentQty, int itemNum) {
        Map m = new HashMap();
        m.put("CURRENT_QTY", currentQty);
        m.put("ITEM_NUM", itemNum);
        m.put("EXPIRY_DATE", new java.sql.Date(System.currentTimeMillis()));
        return m;
    }

    // ───────────────────────── 검증(DB 변경 전) ─────────────────────────

    @Test(expected = RuntimeException.class)
    public void 빈_선택이면_예외를_던지고_claim하지_않는다() {
        try {
            service.confirmShipmentManual(1, "REQ1", 7, 50,
                    new ArrayList<Map>(), false);
        } finally {
            verify(shipmentDAO, never()).confirmShipmentStatus(anyInt());
        }
    }

    @Test(expected = RuntimeException.class)
    public void 합계가_plan보다_크면_예외를_던진다() {
        List<Map> sels = Arrays.asList(sel(10, 60));
        try {
            service.confirmShipmentManual(1, "REQ1", 7, 50, sels, false);
        } finally {
            verify(shipmentDAO, never()).confirmShipmentStatus(anyInt());
            verify(shipmentDAO, never()).insertShipmentLot(any());
        }
    }

    @Test(expected = RuntimeException.class)
    public void 부분출하인데_force가_없으면_예외를_던진다() {
        List<Map> sels = Arrays.asList(sel(10, 30)); // 30 < plan 50
        try {
            service.confirmShipmentManual(1, "REQ1", 7, 50, sels, false);
        } finally {
            verify(shipmentDAO, never()).confirmShipmentStatus(anyInt());
            verify(shipmentDAO, never()).insertShipmentLot(any());
        }
    }

    @Test(expected = RuntimeException.class)
    public void qty가_0이하면_예외를_던진다() {
        List<Map> sels = Arrays.asList(sel(10, 0));
        service.confirmShipmentManual(1, "REQ1", 7, 50, sels, true);
    }

    // ───────────────────────── 정상/분할 경로 ─────────────────────────

    @Test
    public void 부분출하이고_force면_정상처리된다() {
        given(shipmentDAO.confirmShipmentStatus(1)).willReturn(1);
        given(shipmentDAO.selectLotForConfirm(10)).willReturn(lotRow(30, 5)); // qty==current → 직접
        given(shipmentDAO.deductLotQty(any())).willReturn(1);

        List<Map> sels = Arrays.asList(sel(10, 30)); // 30 < plan 50, force
        service.confirmShipmentManual(1, "REQ1", 7, 50, sels, true);

        verify(shipmentDAO).confirmShipmentStatus(1);
        verify(shipmentDAO).insertShipmentLot(any());
        verify(shipmentDAO).deductLotQty(any());
        verify(shipmentDAO).insertShipmentIo(any());
        verify(shipmentDAO).updateRequestStatusToComplete("REQ1");
    }

    @Test
    public void 전량출하_qty가_보유수량과_같으면_직접출고한다() {
        given(shipmentDAO.confirmShipmentStatus(1)).willReturn(1);
        given(shipmentDAO.selectLotForConfirm(10)).willReturn(lotRow(50, 5)); // qty==current
        given(shipmentDAO.deductLotQty(any())).willReturn(1);

        List<Map> sels = Arrays.asList(sel(10, 50)); // ==plan 50
        service.confirmShipmentManual(1, "REQ1", 7, 50, sels, false);

        // 직접 출고: 차감 1회 + IO 1회, 분할 DAO는 호출 안 됨
        verify(shipmentDAO, times(1)).deductLotQty(any());
        verify(shipmentDAO, times(1)).insertShipmentIo(any());
        verify(shipmentDAO, never()).insertSplitLot(any());
        verify(shipmentDAO, never()).insertLotSplit(any());
        verify(shipmentDAO, never()).updateShipmentLotRef(any());
        verify(shipmentDAO).updateRequestStatusToComplete("REQ1");
    }

    @Test
    public void qty가_보유수량보다_작으면_분할경로를_탄다() {
        given(shipmentDAO.confirmShipmentStatus(1)).willReturn(1);
        given(shipmentDAO.selectLotForConfirm(10)).willReturn(lotRow(100, 5)); // qty(50) < current(100)
        given(shipmentDAO.deductLotQty(any())).willReturn(1);
        // insertSplitLot 가 selectKey 로 자식 lot_num 을 채우는 동작을 흉내
        given(shipmentDAO.insertSplitLot(any())).willAnswer(inv -> {
            Map m = inv.getArgument(0);
            m.put("lot_num", 999);
            return 1;
        });

        List<Map> sels = Arrays.asList(sel(10, 50)); // ==plan 50
        service.confirmShipmentManual(1, "REQ1", 7, 50, sels, false);

        // 분할 체인 전부 호출
        verify(shipmentDAO).insertSplitLot(any());
        verify(shipmentDAO).insertLotSplit(any());
        verify(shipmentDAO).updateShipmentLotRef(any());
        verify(shipmentDAO, times(2)).insertShipmentIo(any()); // 분할 + 출하
        verify(shipmentDAO, times(2)).deductLotQty(any());      // 부모 + 자식
        verify(shipmentDAO).updateRequestStatusToComplete("REQ1");
    }

    @Test(expected = RuntimeException.class)
    public void 선택qty가_보유수량보다_크면_stock_error() {
        given(shipmentDAO.confirmShipmentStatus(1)).willReturn(1);
        given(shipmentDAO.selectLotForConfirm(10)).willReturn(lotRow(5, 5)); // current 5
        given(shipmentDAO.deductLotQty(any())).willReturn(0); // 보유 부족 → 영향행 0

        // qty(50)==plan(50) 통과하지만 보유수량(5) 초과 → deduct 0 → stock_error
        List<Map> sels = Arrays.asList(sel(10, 50));
        service.confirmShipmentManual(1, "REQ1", 7, 50, sels, false);
    }

    @Test
    public void 이미_확정된건이면_무작업_종료한다() {
        given(shipmentDAO.confirmShipmentStatus(1)).willReturn(0); // claim 실패(이미 확정/취소)

        List<Map> sels = Arrays.asList(sel(10, 50));
        service.confirmShipmentManual(1, "REQ1", 7, 50, sels, false);

        verify(shipmentDAO, never()).insertShipmentLot(any());
        verify(shipmentDAO, never()).deductLotQty(any());
        verify(shipmentDAO, never()).updateRequestStatusToComplete(anyString());
    }

    // ───────────────────────── dispatch 슬림화 ─────────────────────────

    @Test
    public void dispatch는_자동배정하지_않는다() {
        Map map = new HashMap();
        map.put("shipment_request_num", "REQ1");
        map.put("item_num", 5);
        map.put("plan_qty", 50);
        map.put("emp_num", 7);

        service.dispatchShipment(map);

        verify(shipmentDAO).insertShipment(map);
        verify(shipmentDAO).updateRequestStatusToDispatch("REQ1");
        verify(shipmentDAO, never()).insertShipmentLot(any()); // 지시 단계 자동배정 없음
    }

    // ───────────────────────── 후보 조회(itemNum) ─────────────────────────

    @Test
    public void 후보LOT조회는_빈결과면_빈리스트를_반환한다() {
        given(shipmentDAO.selectShippableLots(5)).willReturn(new ArrayList<ShippableLotDTO>());
        List<ShippableLotDTO> result = service.selectShippableLots(5);
        org.junit.Assert.assertTrue(result.isEmpty());
    }

    @Test
    public void 후보LOT조회는_결과를_그대로_반환한다() {
        ShippableLotDTO dto = new ShippableLotDTO();
        dto.setLot_num(1);
        given(shipmentDAO.selectShippableLots(5)).willReturn(Collections.singletonList(dto));
        List<ShippableLotDTO> result = service.selectShippableLots(5);
        org.junit.Assert.assertEquals(1, result.size());
    }
}
