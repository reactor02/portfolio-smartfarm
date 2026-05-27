package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

public interface RequestDAO {
	public List selectAll(int pageNum);
	public List searchRequest(Map map);
	public List searchVender(String keyword);
	public List loadItems();
	public List loadProducts();
	public int insertRequest(Map map);
}
