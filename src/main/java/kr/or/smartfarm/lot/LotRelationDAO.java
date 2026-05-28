package kr.or.smartfarm.lot;

import java.util.List;
import java.util.Map;

public interface LotRelationDAO {
    void                         insert(LotRelationDTO dto);
    List<LotRelationDTO>         getMaterialsByChildLot(int lot_num);
    List<LotRelationDTO>         getParentsByLot(int lot_num);
    List<Map<String, Object>>    getRecursiveMaterials(int lot_num);
    List<Map<String, Object>>    getLotHistory(int lot_num);
}
