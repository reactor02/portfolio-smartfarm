package kr.or.smartfarm.equipment_log;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import lombok.Data;

@Data
public class EquipDTO {

    private int equip_num;
    private String equip_status;
    private String error_sign;
    private String equip_action;

    private Date maintenance_date;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date start_date;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date end_date;

    private Integer total_runtime;

    private Integer item_num;
    private String code;
    private String name;

    private Integer emp_num;
    private String ename;
}