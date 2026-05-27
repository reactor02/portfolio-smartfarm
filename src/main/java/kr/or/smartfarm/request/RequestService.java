package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

public interface RequestService {
	public List selectAll(int pageNum);
	public List searchBom(Map map);
	public List searchVender(String keyword);
	public List loadItems();
	public int insertRequest(Map map);
}
