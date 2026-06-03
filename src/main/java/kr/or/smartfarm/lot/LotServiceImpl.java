package kr.or.smartfarm.lot;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * LOT 서비스 구현체
 *
 * <p>{@link LotService} 인터페이스를 구현하며, 실제 비즈니스 로직을 수행합니다.
 * {@link LotDAO}와 {@link LotRelationDAO} 두 개의 DAO를 주입받아 사용합니다.</p>
 *
 * <ul>
 *   <li>{@code dao}         : lot 테이블 기본 CRUD (목록, 단건, 삽입, 수량 차감 등)</li>
 *   <li>{@code relationDao} : lot_relation 테이블 + 이력 조회 (재귀 조회, 롯이력 포함)</li>
 * </ul>
 */
@Service
public class LotServiceImpl implements LotService {

    /** lot 테이블 접근 DAO */
    @Autowired
    private LotDAO dao;

    /** lot_relation 테이블 접근 DAO (재귀 소모재료, 롯이력 포함) */
    @Autowired
    private LotRelationDAO relationDao;

    /**
     * LOT 목록 조회 + 페이징 계산
     *
     * <p>Oracle의 ROWNUM 기반 페이징을 위해 page 파라미터를 startRow/endRow로 변환합니다.</p>
     * <p>계산 공식:</p>
     * <ul>
     *   <li>startRow = (page - 1) * size + 1</li>
     *   <li>endRow   = page * size</li>
     * </ul>
     * <p>DB에서 total_count를 함께 받아 totalPages, startPage, endPage를 계산하여
     * pageDTO에 세팅합니다. JSP 페이지네이션 UI가 이 값을 사용합니다.</p>
     *
     * @param page  검색 조건 + 페이지 번호를 담은 DTO (이 메서드 실행 후 페이징 정보도 채워짐)
     * @return      조회된 LOT 목록
     */
    @Override
    public List<LotDTO> getList(LotPageDTO page) {
        // Oracle ROWNUM 범위 계산
        int startRow = (page.getPage() - 1) * page.getSize() + 1;
        int endRow   =  page.getPage()      * page.getSize();
        page.setStartRow(startRow);
        page.setEndRow(endRow);

        List<LotDTO> list = dao.getList(page);

        // 목록이 있을 때만 페이징 정보 계산 (빈 목록이면 페이지 UI를 그릴 필요 없음)
        if (list != null && !list.isEmpty()) {
            int totalCount = list.get(0).getTotal_count();  // COUNT(*) OVER()로 DB에서 받아온 전체 건수
            int totalPages = (int) Math.ceil((double) totalCount / page.getSize());
            // 현재 페이지가 속한 블록의 시작 페이지 (10개 단위 블록 기준)
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
     * lot_code 문자열로 LOT 단건 조회
     *
     * @param lot_code  LOT 코드 (예: "LOT-20250529-123")
     * @return          해당 LOT DTO, 없으면 null
     */
    @Override
    public LotDTO selectOne(String lot_code) {
        return dao.getSelectOne(lot_code);
    }

    /**
     * 품목 드롭다운 옵션 목록 조회
     * (lot 검색 필터의 품목명 selectbox에 표시할 데이터)
     *
     * @return  품목 옵션 목록 (item_num, name, type)
     */
    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return dao.getItemOptions();
    }

    /**
     * 이 LOT 생산에 직접 투입된 소모재료 LOT 목록 조회 (1단계, lot_parent 기준)
     *
     * @param lot_num  생산 LOT의 내부 PK
     * @return         소모재료 LOT 목록
     */
    @Override
    public List<LotRelationDTO> getMaterialsByChildLot(int lot_num) {
        return relationDao.getMaterialsByChildLot(lot_num);
    }

    /**
     * 이 LOT이 소모재료로 투입된 상위 생산 LOT 목록 조회 (lot_child 기준)
     *
     * @param lot_num  소모재료 LOT의 내부 PK
     * @return         상위 생산 LOT 목록
     */
    @Override
    public List<LotRelationDTO> getParentsByLot(int lot_num) {
        return relationDao.getParentsByLot(lot_num);
    }

    /**
     * CONNECT BY 재귀로 모든 단계의 소모재료 트리 조회
     * (lotDetail.jsp의 연관관계 트리 및 소모자재 테이블에 사용)
     *
     * @param lot_num  루트 LOT의 내부 PK
     * @return         재귀 소모재료 목록 (DEPTH, CHILD_LOT_CODE, ITEM_NAME, REQUIRED_QTY 포함)
     */
    @Override
    public List<Map<String, Object>> getRecursiveMaterials(int lot_num) {
        return relationDao.getRecursiveMaterials(lot_num);
    }

    /**
     * 분할 자식 LOT의 원본 LOT 번호를 조회합니다.
     * lot_split 테이블에서 split_lot_num = lot_num 조건으로 origin_lot_num을 반환합니다.
     *
     * @param lot_num  조회 대상 LOT의 내부 PK
     * @return         원본 LOT의 lot_num, 분할 LOT이 아니면 null
     */
    @Override
    public Integer getOriginLotNum(int lot_num) {
        return relationDao.getOriginLotNum(lot_num);
    }

    /**
     * 롯이력 통합 조회 — 분할 LOT이면 원본 LOT 기준으로 생산이력을 해석합니다.
     *
     * <p>분할 LOT(lot_split에 split_lot_num으로 등록된 경우): prodLot = origin_lot_num</p>
     * <p>일반 LOT: prodLot = lot_num</p>
     * <p>출하 블록([3])은 항상 selfLot(= lot_num) 기준으로 조회됩니다.</p>
     *
     * @param lot_num  조회 시작 루트 LOT의 내부 PK
     * @return         롯이력 행 목록 (JSON으로 응답됨)
     */
    @Override
    public List<Map<String, Object>> getLotHistory(int lot_num) {
        Integer origin = relationDao.getOriginLotNum(lot_num);
        int prodLot = (origin != null) ? origin : lot_num;
        Map<String, Object> param = new HashMap<>();
        param.put("prodLot", prodLot);
        param.put("selfLot", lot_num);
        return relationDao.getLotHistory(param);
    }
}
