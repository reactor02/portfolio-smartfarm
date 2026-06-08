package kr.or.smartfarm.lot;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;
import static org.mockito.BDDMockito.given;   // BDD: stub (given ~ willReturn)
import static org.mockito.BDDMockito.then;     // BDD: 호출 검증 (then ~ should)

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

/**
 * {@link LotServiceImpl#getLotHistory(int)} 의 분기 동작을 BDD 함수로 검증.
 *
 * <p>규칙: 분할 LOT(origin 있음)이면 생산이력은 origin 기준(prodLot=origin),
 * 일반 LOT이면 자기 자신 기준(prodLot=lot_num). 출하는 항상 selfLot=lot_num.</p>
 *
 * <p>given()/willReturn() 로 DAO 응답을 깔고, then()/should() 로 DAO에
 * 어떤 파라미터가 넘어갔는지 검증한다.</p>
 */
@RunWith(MockitoJUnitRunner.class)
public class LotHistoryBddTest {

    @Mock
    private LotDAO dao;

    @Mock
    private LotRelationDAO relationDao;

    @InjectMocks
    private LotServiceImpl service;

    /** relationDao.getLotHistory 에 실제로 넘어간 param Map 을 잡아낸다. */
    @Captor
    private ArgumentCaptor<Map<String, Object>> paramCaptor;

    @Test
    public void 분할LOT이면_생산이력은_원본LOT_기준으로_조회한다() {
        // given: lot_num=200 은 분할 LOT, 원본은 100
        int lotNum = 200;
        int originNum = 100;
        List<Map<String, Object>> fakeHistory = new ArrayList<Map<String, Object>>();
        given(relationDao.getOriginLotNum(lotNum)).willReturn(originNum);
        given(relationDao.getLotHistory(paramCaptor.capture())).willReturn(fakeHistory);

        // when
        List<Map<String, Object>> result = service.getLotHistory(lotNum);

        // then: DAO 결과를 그대로 돌려준다
        assertSame(fakeHistory, result);

        // then: 생산은 원본(100), 출하 기준은 자기 자신(200) 으로 넘어갔다
        Map<String, Object> param = paramCaptor.getValue();
        assertEquals("prodLot 은 원본 LOT", 100, param.get("prodLot"));
        assertEquals("selfLot 은 자기 자신", 200, param.get("selfLot"));

        // then: origin 조회 1회, history 조회 1회만 호출됐다
        then(relationDao).should().getOriginLotNum(lotNum);
        then(relationDao).should().getLotHistory(param);
    }

    @Test
    public void 일반LOT이면_생산이력은_자기자신_기준으로_조회한다() {
        // given: lot_num=300 은 분할이 아님 → origin 조회 시 null
        int lotNum = 300;
        given(relationDao.getOriginLotNum(lotNum)).willReturn(null);
        given(relationDao.getLotHistory(paramCaptor.capture()))
                .willReturn(new ArrayList<Map<String, Object>>());

        // when
        service.getLotHistory(lotNum);

        // then: 분할이 아니므로 prodLot, selfLot 모두 자기 자신(300)
        Map<String, Object> param = paramCaptor.getValue();
        assertEquals(300, param.get("prodLot"));
        assertEquals(300, param.get("selfLot"));
    }
}
