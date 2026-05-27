package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

public interface LotDAO {
    List<LotDTO>          getList(LotPageDTO page);
    LotDTO                getSelectOne(String lot_code);
    List<SelectOptionDTO> getItemOptions();

    // 생산 완료 시 LOT 생성 관련
    void           insertLot(LotDTO dto);
    void           deductQty(int lot_num, int deduct_qty);
    List<LotDTO>   getQcPassedLotsFIFO(int item_num);
}
