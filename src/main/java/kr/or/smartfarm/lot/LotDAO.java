package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

public interface LotDAO {
    List<LotDTO>          getList(LotPageDTO page);
    LotDTO                getSelectOne(String lot_code);
    List<SelectOptionDTO> getItemOptions();
}
