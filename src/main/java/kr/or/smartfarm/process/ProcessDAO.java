package kr.or.smartfarm.process;

import java.util.List;
import java.util.Map;

public interface ProcessDAO{
	
	public List selectAll2(int pageNum);
	public List selectDetail2(int itemNum);
	public List searchProcess2(Map map);
	public List modalSearch2(String str);
	public int insertProcess2(ProcessDTO dto);
	public void updateStatus2(ProcessDTO dto);
}
