package kr.or.smartfarm.equipment_log;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

}
