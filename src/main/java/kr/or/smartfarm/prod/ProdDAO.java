package kr.or.smartfarm.prod;

import java.util.List;
import java.util.Map;

import kr.or.smartfarm.work.WorkDTO;

public interface ProdDAO {

    public List<ProdDTO>         getList(ProdPageDTO page);
    public List<SelectOptionDTO> getEmpList();
    public List<SelectOptionDTO> getFacilityOptions();
    public List<SelectOptionDTO> getItemOptions();
    public ProdDTO               getSelectOne(String plan_id);
    public int                   create(ProdDTO prodDTO);
    public int                   updateStatus(ProdDTO prodDTO);
    public int                   syncPlanStatus();
    public List<WorkDTO>         getWorkOrders(Map<String, Object> params);
}
