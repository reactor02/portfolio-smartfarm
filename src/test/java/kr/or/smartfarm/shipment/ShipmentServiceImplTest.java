package kr.or.smartfarm.shipment;

import static org.junit.Assert.assertEquals;
import static org.mockito.BDDMockito.given;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

/**
 * 출하관리 상세 — LOT 선택 시 유통기한 검증 로직 검증.
 *
 * <p>DB 없이 {@link ShipmentDAO} 를 Mockito mock 으로 주입하고,
 * {@link ShipmentServiceImpl#selectLotExpiry(int)} 의 순수 비교 로직만 검증한다.</p>
 *
 * <ul>
 *   <li>유통기한 &lt; sysdate (이미 지남) → -1 반환</li>
 *   <li>유통기한 &gt; sysdate (아직 남음) → 유통기한 Date 그대로 반환</li>
 * </ul>
 */
@RunWith(MockitoJUnitRunner.class)
public class ShipmentServiceImplTest {

    private static final long ONE_DAY = 24L * 60 * 60 * 1000;

    @Mock
    private ShipmentDAO shipmentDAO;

    @InjectMocks
    private ShipmentServiceImpl service;

    @Test
    public void 유통기한이_sysdate보다_작으면_minus1을_반환한다() {
        // given: 어제 날짜(이미 지난 유통기한)인 LOT
        Date past = new Date(System.currentTimeMillis() - ONE_DAY);
        given(shipmentDAO.getLotExpiry(1)).willReturn(past);

        // when
        Object result = service.selectLotExpiry(1);

        // then
        assertEquals(-1, result);
    }

    @Test
    public void 유통기한이_sysdate보다_크면_날짜를_반환한다() {
        // given: 내일 날짜(아직 남은 유통기한)인 LOT
        Date future = new Date(System.currentTimeMillis() + ONE_DAY);
        given(shipmentDAO.getLotExpiry(1)).willReturn(future);

        // when
        Object result = service.selectLotExpiry(1);

        // then
        assertEquals(future, result);
    }

    @Test(expected = RuntimeException.class)
    public void 유통기한이_안_지난_롯이_하나도_없으면_에러를_던진다() {
        // given: 모든 LOT의 유통기한이 sysdate보다 빠름(전부 이미 지남 → 유효한 롯 없음)
        Date past1 = new Date(System.currentTimeMillis() - ONE_DAY);
        Date past2 = new Date(System.currentTimeMillis() - 2 * ONE_DAY);
        given(shipmentDAO.getShipmentLotExpiries(1))
                .willReturn(Arrays.asList(past1, past2));

        // when: 유통기한 안 지난 롯이 하나도 없으므로 예외 발생
        service.validateUsableLotExists(1);
    }

    @Test
    public void 유통기한이_안_지난_롯이_하나라도_있으면_통과한다() {
        // given: 하나는 이미 지남(어제), 하나는 아직 남음(내일 → 유효)
        Date past   = new Date(System.currentTimeMillis() - ONE_DAY);
        Date future = new Date(System.currentTimeMillis() + ONE_DAY);
        given(shipmentDAO.getShipmentLotExpiries(1))
                .willReturn(Arrays.asList(past, future));

        // when: 유효한 롯이 하나라도 있으므로 예외 없이 통과
        service.validateUsableLotExists(1);
    }

    @Test(expected = RuntimeException.class)
    public void type이_product가_아니면_에러를_던진다() {
        // given: 해당 LOT의 품목 타입이 PRODUCT가 아님
        given(shipmentDAO.getLotItemType(1)).willReturn("MATERIAL");

        // when: 출하 불가 → 예외
        service.validateLotForShipment(1);
    }

    @Test(expected = RuntimeException.class)
    public void 이미_shipment_lot에_배정된_롯이면_에러를_던진다() {
        // given: 타입은 PRODUCT(1차 통과)지만 이미 shipment_lot에 들어가 있음
        given(shipmentDAO.getLotItemType(1)).willReturn("PRODUCT");
        given(shipmentDAO.countShipmentLotByLotNum(1)).willReturn(1);

        // when: 중복 배정 → 예외
        service.validateLotForShipment(1);
    }

    @Test
    public void product이고_미배정_롯이면_통과한다() {
        // given: PRODUCT 타입이고 shipment_lot에 없음
        given(shipmentDAO.getLotItemType(1)).willReturn("PRODUCT");
        given(shipmentDAO.countShipmentLotByLotNum(1)).willReturn(0);

        // when: 예외 없이 정상 통과해야 한다
        service.validateLotForShipment(1);
    }

    @Test(expected = RuntimeException.class)
    public void 검증을_통과한_롯이_하나도_없으면_에러를_던진다() {
        // given: 후보 1·2번 모두 부적격 (1번=타입 아님, 2번=이미 배정)
        given(shipmentDAO.getLotItemType(1)).willReturn("MATERIAL");
        given(shipmentDAO.getLotItemType(2)).willReturn("PRODUCT");
        given(shipmentDAO.countShipmentLotByLotNum(2)).willReturn(1);

        // when: 담을 롯이 하나도 없으므로 예외 발생
        service.collectShippableLots(Arrays.asList(1, 2));
    }

    @Test
    public void 검증을_통과한_롯이_하나라도_있으면_list에_담아_반환한다() {
        // given: 1번=부적격(타입 아님), 2번=적격(PRODUCT·미배정)
        given(shipmentDAO.getLotItemType(1)).willReturn("MATERIAL");
        given(shipmentDAO.getLotItemType(2)).willReturn("PRODUCT");
        given(shipmentDAO.countShipmentLotByLotNum(2)).willReturn(0);

        // when
        List<Integer> result = service.collectShippableLots(Arrays.asList(1, 2));

        // then: 적격인 2번만 담겨야 한다
        assertEquals(1, result.size());
        assertEquals(Integer.valueOf(2), result.get(0));
    }

    // selectShippableLots(int) 및 confirmShipmentManual 검증은 ShipmentConfirmManualTest 참고
}
