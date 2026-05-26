package kr.or.smartfarm.work;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.prod.SelectOptionDTO;

public interface WorkService {
    List<WorkDTO>         getList(WorkPageDTO page);
    WorkDTO               selectOne(String work_order_id);
    int                   create(WorkDTO workDTO);
    void                  cancel(String work_order_id);
    void                  start(String work_order_id);
    void                  complete(String work_order_id);
    void                  produce(String work_order_id);
    List<SelectOptionDTO> getEmpOptions();
    List<SelectOptionDTO> getPlanOptions();
    List<SelectOptionDTO> getItemOptions();
    Map<String, Object>   searchPlans(String keyword, int page);
}
