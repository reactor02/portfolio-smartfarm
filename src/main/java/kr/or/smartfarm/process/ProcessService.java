package kr.or.smartfarm.process;

import java.util.List;

public interface ProcessService {

	public List selectAll(int pageNum);
	
	public List selectDetail(int itemNum);
}
