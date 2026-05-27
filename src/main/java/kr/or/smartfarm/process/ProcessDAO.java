package kr.or.smartfarm.process;

import java.util.List;

public interface ProcessDAO{
	
	public List selectAll2(int pageNum);
	public List selectDetail2(int itemNum);
	
}
