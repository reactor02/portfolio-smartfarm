package kr.or.smartfarm.stock;

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
}
