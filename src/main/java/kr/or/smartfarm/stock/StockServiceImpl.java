package kr.or.smartfarm.stock;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StockServiceImpl implements StockService{

	@Autowired
	StockDAO stockDAO;
	
	public List selectAll(int pageNum) {
		List result = null;
		
		result = stockDAO.selectAll2(pageNum);
		
		return result;
	}
	
	public List searchStock(Map map) {
		List result = null;
		
		 result = stockDAO.searchStock2(map);
		return result;
	}
	
	public Map modalSearch(String str) {
		Map result = new HashMap();
		List result2 = stockDAO.modalSearch2(str);
		result.put("result", result2);
		return result;
	}
public int insertStock(StockDTO dto) {
		int result = 0;
		result = stockDAO.insertStock2(dto);
	return result;
	}
}
