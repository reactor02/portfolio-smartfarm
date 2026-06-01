package kr.or.smartfarm.defective;

import java.util.List;
import java.util.Map;


public interface DefectiveDAO {
	
	public List selectAll(int pageNum); 
	public List selectQcType(); 
	public List searchDefect(Map map);
	
}
