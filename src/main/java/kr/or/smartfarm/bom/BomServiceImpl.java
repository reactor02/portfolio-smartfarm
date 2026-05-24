package kr.or.smartfarm.bom;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BomServiceImpl implements BomService{

	@Autowired
	BomDAO bomDAO;
	
	public List selectAll(int pageNum) {
		List result = null;
		
		result = bomDAO.selectAll2(pageNum);
		return result;
	}
	
	@Override
	public List searchBom(Map map) {
		List result = null;
		
		 result = bomDAO.searchBom2(map);
		return result;
	}
	
}
