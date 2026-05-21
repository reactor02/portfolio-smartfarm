package kr.or.smartfarm.work;

import java.util.List;

public interface WorkDAO {
    List<WorkDTO> getList(WorkPageDTO page);
    WorkDTO       getSelectOne(String work_order_id);
    int           create(WorkDTO workDTO);
    int           updateStatus(WorkDTO workDTO);
}
