package kr.or.smartfarm.stock;

import java.util.List;
import java.util.Map;

public interface StockService {

	public List selectAll(int pageNum);
	public List searchStock(Map map);
	public Map modalSearch(String str);
	public int insertStock(StockDTO dto);
	public List selectDetail(String stockId);
	
}
