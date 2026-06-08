package kr.or.smartfarm.lot;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

/**
 * {@link LotServiceImpl#getList(LotPageDTO)} 의 페이징 계산 로직 검증.
 *
 * <p>DB 없이 {@link LotDAO} 를 Mockito 로 가짜(mock)로 만들어 주입하고,
 * BDD 스타일(given / when / then)로 순수 계산 결과만 검증한다.</p>
 */
@RunWith(MockitoJUnitRunner.class)
public class LotServiceImplTest {

    @Mock
    private LotDAO dao;

    @Mock
    private LotRelationDAO relationDao;

    @InjectMocks
    private LotServiceImpl service;

    /** total_count 가 세팅된 LOT 한 건을 만든다. */
    private LotDTO lotWithTotalCount(int totalCount) {
        LotDTO dto = new LotDTO();
        dto.setTotal_count(totalCount);
        return dto;
    }

    @Test
    public void 목록이_있으면_페이징_정보를_계산한다() {
        // given: 2페이지, 페이지당 10건, 전체 55건
        LotPageDTO page = new LotPageDTO();
        page.setPage(2);
        page.setSize(10);
        page.setBlockSize(10);

        List<LotDTO> dbResult = Arrays.asList(lotWithTotalCount(55));
        given(dao.getList(page)).willReturn(dbResult);

        // when
        List<LotDTO> result = service.getList(page);

        // then: ROWNUM 범위
        assertEquals("startRow = (2-1)*10 + 1", 11, page.getStartRow());
        assertEquals("endRow = 2*10", 20, page.getEndRow());

        // then: 페이징 메타
        assertEquals("전체 건수", 55, page.getTotalCount());
        assertEquals("ceil(55/10) = 6", 6, page.getTotalPages());
        assertEquals("첫 블록 시작 페이지", 1, page.getStartPage());
        assertEquals("min(1+10-1, 6) = 6", 6, page.getEndPage());

        // then: DAO 결과 그대로 반환 + DAO 정확히 1회 호출
        assertEquals(dbResult, result);
        then(dao).should(times(1)).getList(page);
    }

    @Test
    public void 두번째_블록이면_startPage가_11이다() {
        // given: 12페이지 (블록 크기 10 → 11~20 블록), 충분히 큰 전체 건수
        LotPageDTO page = new LotPageDTO();
        page.setPage(12);
        page.setSize(10);
        page.setBlockSize(10);

        given(dao.getList(page)).willReturn(Arrays.asList(lotWithTotalCount(250)));

        // when
        service.getList(page);

        // then
        assertEquals("startRow = (12-1)*10 + 1", 111, page.getStartRow());
        assertEquals("두번째 블록의 시작 페이지", 11, page.getStartPage());
        assertEquals("min(11+10-1, 25) = 20", 20, page.getEndPage());
        assertEquals("ceil(250/10) = 25", 25, page.getTotalPages());
    }

    @Test
    public void 마지막_블록은_endPage가_totalPages를_넘지_않는다() {
        // given: 전체 23페이지 분량인데 마지막 블록(21~) 진입
        LotPageDTO page = new LotPageDTO();
        page.setPage(21);
        page.setSize(10);
        page.setBlockSize(10);

        given(dao.getList(page)).willReturn(Arrays.asList(lotWithTotalCount(225)));

        // when
        service.getList(page);

        // then: endPage 는 totalPages(23) 로 잘린다 (21~30 이 아님)
        assertEquals(23, page.getTotalPages());
        assertEquals(21, page.getStartPage());
        assertEquals("min(21+10-1, 23) = 23", 23, page.getEndPage());
    }

    @Test
    public void 목록이_비어있으면_페이징_정보를_계산하지_않는다() {
        // given: DAO 가 빈 목록 반환
        LotPageDTO page = new LotPageDTO();
        page.setPage(3);
        page.setSize(10);
        page.setBlockSize(10);

        given(dao.getList(page)).willReturn(new ArrayList<LotDTO>());

        // when
        List<LotDTO> result = service.getList(page);

        // then: ROWNUM 범위는 계산되지만, 페이징 메타는 기본값(0) 유지
        assertEquals("startRow 는 계산됨", 21, page.getStartRow());
        assertEquals("endRow 는 계산됨", 30, page.getEndRow());
        assertEquals("빈 목록이면 totalPages 미계산", 0, page.getTotalPages());
        assertEquals("빈 목록이면 totalCount 미계산", 0, page.getTotalCount());
        assertTrue(result.isEmpty());
    }

    @Test
    public void 목록이_null이면_NPE없이_null을_반환한다() {
        // given: DAO 가 null 반환 (방어 로직 검증)
        LotPageDTO page = new LotPageDTO();
        page.setPage(1);
        page.setSize(5);
        page.setBlockSize(10);

        given(dao.getList(page)).willReturn(null);

        // when
        List<LotDTO> result = service.getList(page);

        // then
        assertEquals(null, result);
        assertEquals(0, page.getTotalPages());
        // relationDao 는 getList 흐름과 무관 → 한 번도 호출되지 않아야 함
        then(relationDao).should(never()).getRouteByItem(org.mockito.ArgumentMatchers.anyInt());
    }
}
