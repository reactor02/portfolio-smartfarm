package kr.or.smartfarm.work;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.bom.BomDTO;
import kr.or.smartfarm.prod.ProdDTO;
import kr.or.smartfarm.prod.SelectOptionDTO;

public interface WorkDAO {
    List<WorkDTO>         getList(WorkPageDTO page);
    WorkDTO               getSelectOne(String work_order_id);
    int                   create(WorkDTO workDTO);
    int                   updateStatus(WorkDTO workDTO);
    int                   produce(WorkDTO workDTO);
    int                   completePlanIfDone(String work_order_id);
    List<SelectOptionDTO> getEmpOptions();
    List<SelectOptionDTO> getPlanOptions();
    List<SelectOptionDTO> getItemOptions();
    List<ProdDTO>         searchPlans(Map<String, Object> params);
    List<BomDTO>          getMaterialsByItem(int item_num);
    void                  insertIo(Map<String, Object> params);
}
