package kr.or.smartfarm.prod;

import java.util.List;
import java.util.Map;

public interface ProdService {
    List<ProdDTO>         getList(ProdPageDTO page);
    ProdDTO               selectOne(String plan_id);
    int                   create(ProdDTO prodDTO);
    List<SelectOptionDTO> getEmpList();
    List<SelectOptionDTO> getFacilityOptions();
    List<SelectOptionDTO> getItemOptions();
    void                  updateStatus(String plan_id, String status);
    Map<String, Object>   getWorkOrders(int plan_num, int page);
}
