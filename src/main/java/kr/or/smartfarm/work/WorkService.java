package kr.or.smartfarm.work;

import java.util.List;

public interface WorkService {
    List<WorkDTO> getList(WorkPageDTO page);
    WorkDTO       selectOne(String work_order_id);
    int           create(WorkDTO workDTO);
    void          cancel(String work_order_id);
}
