package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

public interface LotService {
    List<LotDTO>          getList(LotPageDTO page);
    LotDTO                selectOne(String lot_code);
    List<SelectOptionDTO> getItemOptions();
}
