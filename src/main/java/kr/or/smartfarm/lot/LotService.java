package kr.or.smartfarm.lot;

import java.util.List;

public interface LotService {
    List<LotDTO> getList(LotPageDTO page);
    LotDTO selectOne(String lot_code);
}
