package kr.or.smartfarm.lot;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * LOT DAO 구현체.
 *
 * <p>MyBatis {@link SqlSession}으로 lot.xml의 {@code kr.or.smartfarm.lot.*}
 * statement를 호출한다. LOT 목록/단건 조회, 신규 LOT 생성, 수량 차감,
 * QC 통과 LOT FIFO 조회를 담당한다.</p>
 */
@Repository
public class LotDAOImpl implements LotDAO {

    /** MyBatis SQL 실행 세션 */
    @Autowired
    private SqlSession session;

    /** LOT 목록 조회 (ROWNUM 페이징, total_count 동반) */
    @Override
    public List<LotDTO> getList(LotPageDTO page) {
        // [방어] 빈 목록일 때 a.get(0) 접근이 NPE/IndexOutOfBounds를 유발하던 디버그 출력 제거.
        //        조회 결과를 그대로 반환만 한다.
        return session.selectList("kr.or.smartfarm.lot.getList", page);
    }

    /** lot_code로 LOT 단건 조회 */
    @Override
    public LotDTO getSelectOne(String lot_code) {
        return session.selectOne("kr.or.smartfarm.lot.getOne", lot_code);
    }

    /** 검색 필터 품목 드롭다운 옵션 */
    @Override
    public List<SelectOptionDTO> getItemOptions() {
        return session.selectList("kr.or.smartfarm.lot.getItemOptions");
    }

    /** 신규 LOT 생성 (생산결과 LOT 등록, selectKey로 lot_num 채번) */
    @Override
    public void insertLot(LotDTO dto) {
        session.insert("kr.or.smartfarm.lot.insertLot", dto);
    }

    /** LOT 현재 수량 차감 (lot.xml의 가드: 보유 수량 이상/음수 차감 불가) */
    @Override
    public void deductQty(int lot_num, int deduct_qty) {
        Map<String, Integer> param = new HashMap<String, Integer>();
        param.put("lot_num",    lot_num);
        param.put("deduct_qty", deduct_qty);
        session.update("kr.or.smartfarm.lot.deductQty", param);
    }

    /** 품목의 QC 통과 + 유통기한 내 LOT을 FIFO(오래된 순)로 조회 — 생산 자재 차감 기준 */
    @Override
    public List<LotDTO> getQcPassedLotsFIFO(int item_num) {
        return session.selectList("kr.or.smartfarm.lot.getQcPassedLotsFIFO", item_num);
    }
}
