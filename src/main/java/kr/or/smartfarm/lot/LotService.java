package kr.or.smartfarm.lot;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

public interface LotService {
    List<LotDTO>             getList(LotPageDTO page);
    LotDTO                   selectOne(String lot_code);
    List<SelectOptionDTO>    getItemOptions();
    List<LotRelationDTO>     getMaterialsByChildLot(int lot_num);
    List<LotRelationDTO>     getParentsByLot(int lot_num);
}
