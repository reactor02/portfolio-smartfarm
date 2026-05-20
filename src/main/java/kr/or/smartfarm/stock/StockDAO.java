package kr.or.smartfarm.stock;

import java.util.List;
import java.util.Map;

public interface StockDAO {
	
	public List selectAll2(int pageNum); 
	public List searchStock2(Map map);
	public Map modalSearch2(String str);
}
