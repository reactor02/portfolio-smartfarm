package kr.or.smartfarm.lot;

import java.util.List;

public interface LotDAO {
    List<LotDTO> getList(LotPageDTO page);
    LotDTO getSelectOne(String lot_code);
}
