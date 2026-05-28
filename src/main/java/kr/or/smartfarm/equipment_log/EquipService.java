package kr.or.smartfarm.equipment_log;

import java.util.List;
import java.util.Map;


public interface EquipService {

	public List selectAll(int pageNum);
	public List selectItemEquip();
	public List selectEmp();
	public List searchEquip(Map map);
	public int insertEquip(EquipDTO dto);
}
