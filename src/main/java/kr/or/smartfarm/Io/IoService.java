package kr.or.smartfarm.io;

import java.util.List;
import java.util.Map;

public interface IoService {
	public List selectAll(int pageNum);
	public List searchIo(Map map);
	public List facility();
	public List modalSearch(String keyword);
}
