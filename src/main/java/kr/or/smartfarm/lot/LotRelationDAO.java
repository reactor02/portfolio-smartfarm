package kr.or.smartfarm.lot;

import java.util.List;

public interface LotRelationDAO {
    void              insert(LotRelationDTO dto);
    List<LotRelationDTO> getMaterialsByChildLot(int lot_num);
    List<LotRelationDTO> getParentsByLot(int lot_num);
}
