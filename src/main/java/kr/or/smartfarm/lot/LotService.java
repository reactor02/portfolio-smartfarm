package kr.or.smartfarm.lot;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.prod.SelectOptionDTO;

/**
 * LOT 관리 서비스 인터페이스
 *
 * <p>LOT와 관련된 모든 비즈니스 로직의 진입점입니다.
 * 컨트롤러(LotController)는 이 인터페이스만 의존하며,
 * 실제 구현은 {@link LotServiceImpl}이 담당합니다.</p>
 *
 * <p>주요 책임:</p>
 * <ul>
 *   <li>LOT 목록 조회 (페이징 계산 포함)</li>
 *   <li>LOT 단건 조회</li>
 *   <li>품목 드롭다운 옵션 제공</li>
 *   <li>LOT 연관관계 조회 (소모자재, 상위투입, 재귀 트리)</li>
 *   <li>롯이력 통합 조회 (생산공정 + 출하이력, 자식 LOT 재귀)</li>
 * </ul>
 */
public interface LotService {

    /**
     * LOT 목록을 페이징 및 필터 조건에 따라 조회합니다.
     * 서비스 구현체에서 페이지 번호를 Oracle ROWNUM 범위(startRow ~ endRow)로 변환하고,
     * 전체 페이지 수·블록 범위도 계산하여 pageDTO에 세팅합니다.
     *
     * @param page  검색 조건(기간, 품목분류, 키워드 등)과 페이지 정보를 담은 DTO
     * @return      조회된 LOT 목록 (각 항목에 total_count 포함)
     */
    List<LotDTO>                  getList(LotPageDTO page);

    /**
     * lot_code(LOT 코드 문자열)로 LOT 단건을 조회합니다.
     *
     * @param lot_code  예: "LOT-20250529-123"
     * @return          해당 LOT의 상세 정보, 없으면 null
     */
    LotDTO                        selectOne(String lot_code);

    /**
     * 검색 필터의 품목명 드롭다운에 표시할 옵션 목록을 반환합니다.
     * MATERIAL, SEMIPRODUCT, RAW, PRODUCT 유형의 품목을 모두 포함합니다.
     *
     * @return  품목 번호·이름·유형을 담은 SelectOptionDTO 목록
     */
    List<SelectOptionDTO>         getItemOptions();

    /**
     * 특정 생산 LOT에 직접 투입된 소모재료 LOT 목록을 조회합니다. (1단계)
     * lot_relation 테이블의 lot_parent = lot_num 조건으로 조회합니다.
     *
     * @param lot_num  생산 LOT의 내부 PK
     * @return         소모재료 LOT 목록 (재료명, 소모 수량 포함)
     */
    List<LotRelationDTO>          getMaterialsByChildLot(int lot_num);

    /**
     * 특정 LOT이 소모재료로 투입된 상위 생산 LOT 목록을 조회합니다.
     * lot_relation 테이블의 lot_child = lot_num 조건으로 조회합니다.
     *
     * @param lot_num  소모재료 LOT의 내부 PK
     * @return         이 LOT을 투입한 상위 생산 LOT 목록
     */
    List<LotRelationDTO>          getParentsByLot(int lot_num);

    /**
     * CONNECT BY 재귀 쿼리로 모든 단계의 소모재료 트리를 조회합니다.
     * depth 값으로 각 재료의 트리 깊이를 알 수 있어 들여쓰기 표현에 사용합니다.
     *
     * @param lot_num  루트 LOT의 내부 PK
     * @return         Map 형태의 재귀 소모재료 목록 (DEPTH, CHILD_LOT_CODE, ITEM_NAME, REQUIRED_QTY 키 포함)
     */
    List<Map<String, Object>>     getRecursiveMaterials(int lot_num);

    /**
     * 분할 자식 LOT의 원본 LOT 번호를 조회합니다.
     * lot_split 테이블에서 split_lot_num = lot_num 조건으로 origin_lot_num을 반환합니다.
     *
     * @param lot_num  조회 대상 LOT의 내부 PK
     * @return         원본 LOT의 lot_num, 분할 LOT이 아니면 null
     */
    Integer                       getOriginLotNum(int lot_num);

    /**
     * 롯이력 통합 조회 — 생산공정과 출하이력을 하나의 테이블에 통합하여 반환합니다.
     *
     * <p>조회 범위: 루트 LOT + CONNECT BY 재귀로 탐색한 모든 자식 LOT</p>
     * <p>각 행은 Map으로 반환되며 컨트롤러에서 JSON으로 직렬화됩니다.</p>
     * <p>분할 LOT의 경우 origin LOT 기준으로 생산이력을 해석합니다.</p>
     * <p>상세 쿼리 로직은 lot.xml의 getLotHistory 쿼리 주석을 참고하세요.</p>
     *
     * @param lot_num  조회 시작점인 루트 LOT의 내부 PK
     * @return         롯이력 행 목록 (DEPTH, GUBUN, ID_COL, CONTENT_COL, DATE_COL, STATUS_COL, WORKER 포함)
     */
    List<Map<String, Object>>     getLotHistory(int lot_num);
}
