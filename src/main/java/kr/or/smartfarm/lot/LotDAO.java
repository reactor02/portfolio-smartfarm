package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

/**
 * LOT 기본 CRUD DAO 인터페이스
 *
 * <p>lot 테이블을 직접 조작하는 메서드를 정의합니다.
 * 구현체는 {@link LotDAOImpl}이며, MyBatis SqlSession을 통해
 * lot.xml 매퍼 쿼리를 실행합니다.</p>
 *
 * <p>주요 역할:</p>
 * <ul>
 *   <li>LOT 목록·단건 조회 (화면 표시용)</li>
 *   <li>LOT 신규 등록 (생산 완료 시 자동 생성)</li>
 *   <li>LOT 현재 수량 차감 (출하 확정 시 호출)</li>
 *   <li>QC 합격 + 유통기한 내 LOT FIFO 조회 (출하 LOT 자동 할당용)</li>
 * </ul>
 */
public interface LotDAO {

    /**
     * LOT 목록 조회 — 페이징 + 다중 필터 지원
     *
     * @param page  검색 조건(기간, 품목분류, 키워드 등)과 ROWNUM 범위를 담은 DTO
     * @return      페이지에 해당하는 LOT 목록 (각 항목에 total_count 포함)
     */
    List<LotDTO>          getList(LotPageDTO page);

    /**
     * lot_code(LOT 코드 문자열)로 LOT 단건 조회
     *
     * @param lot_code  LOT 코드 (예: "LOT-20250529-123")
     * @return          해당 LOT DTO, 없으면 null
     */
    LotDTO                getSelectOne(String lot_code);

    /**
     * 품목 드롭다운 옵션 목록 조회
     * (MATERIAL, SEMIPRODUCT, RAW, PRODUCT 유형 품목 전체)
     *
     * @return  품목 옵션 목록 (item_num, name, type)
     */
    List<SelectOptionDTO> getItemOptions();

    // 생산 완료 시 LOT 생성 관련

    /**
     * 생산 완료 이벤트 발생 시 새 LOT을 등록합니다.
     * lot_num은 LOT_SEQ 시퀀스로 자동 채번되며,
     * lot_code는 "LOT-YYYYMMDD-{lot_num}" 형식으로 DB에서 자동 생성됩니다.
     * 만료일은 반제품이면 +10일, 완제품이면 +20일로 설정됩니다.
     *
     * @param dto  등록할 LOT 정보 (item_num, order_num, init_qty, current_qty, type 필수)
     */
    void           insertLot(LotDTO dto);

    /**
     * LOT의 현재 수량(current_qty)을 차감합니다.
     * 출하 확정 또는 소모 처리 시 호출되며,
     * current_qty가 차감량보다 작으면 UPDATE가 실행되지 않습니다(안전 조건).
     *
     * @param lot_num    수량을 차감할 LOT의 내부 PK
     * @param deduct_qty 차감할 수량
     */
    void           deductQty(int lot_num, int deduct_qty);

    /**
     * 출하 LOT 자동 할당을 위한 FIFO 조회
     *
     * <p>특정 품목(item_num)의 LOT 중 다음 조건을 모두 만족하는 항목을 오래된 순으로 반환합니다.</p>
     * <ul>
     *   <li>current_qty > 0 (재고가 남아 있음)</li>
     *   <li>expiry_date >= SYSDATE (유통기한 내)</li>
     *   <li>QC 검사 결과 PASS 판정을 받은 적 있음</li>
     * </ul>
     * <p>lot_date ASC 정렬로 먼저 생성된 LOT부터 소비하는 FIFO 원칙을 따릅니다.</p>
     *
     * @param item_num  조회할 품목의 내부 PK
     * @return          조건을 만족하는 LOT 목록 (lot_num, current_qty, lot_date, qc_num 포함)
     */
    List<LotDTO>   getQcPassedLotsFIFO(int item_num);
}
