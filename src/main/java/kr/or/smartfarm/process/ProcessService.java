package kr.or.smartfarm.process;

import java.util.List;
import java.util.Map;

public interface ProcessService {

	public List selectAll(int pageNum);
	public List selectDetail(int itemNum);
	public List searchProcess(Map map);
	public Map modalSearch(String str);
}
