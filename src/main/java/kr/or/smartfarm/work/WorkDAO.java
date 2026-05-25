package kr.or.smartfarm.work;

import java.util.List;

import kr.or.smartfarm.prod.SelectOptionDTO;

public interface WorkDAO {
    List<WorkDTO>         getList(WorkPageDTO page);
    WorkDTO               getSelectOne(String work_order_id);
    int                   create(WorkDTO workDTO);
    int                   updateStatus(WorkDTO workDTO);
    int                   produce(WorkDTO workDTO);
    List<SelectOptionDTO> getEmpOptions();
    List<SelectOptionDTO> getPlanOptions();
    List<SelectOptionDTO> getItemOptions();
}
