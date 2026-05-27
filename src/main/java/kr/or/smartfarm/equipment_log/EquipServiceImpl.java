package kr.or.smartfarm.equipment_log;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.smartfarm.stock.StockDTO;

@Service
public class EquipServiceImpl implements EquipService{

	@Autowired
	EquipDAO equipDAO;

	@Override
	public List selectAll(int pageNum) {
		
		List result = new ArrayList();
		
		result = equipDAO.selectAll(pageNum);
		
		return result; 
	}

	@Override
	public List selectItemEquip() {
		return equipDAO.selectItemEquip();
	}
	@Override
	public List selectEmp() {
		return equipDAO.selectEmp();
	}
	
	public List searchEquip(Map map) {
		return equipDAO.searchEquip(map);
	}
	
	public int insertEquip(EquipDTO dto) {
		return equipDAO.insertEquip(dto);
	}


}
