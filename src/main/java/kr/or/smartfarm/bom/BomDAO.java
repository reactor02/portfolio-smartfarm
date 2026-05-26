package kr.or.smartfarm.bom;

import java.util.List;
import java.util.Map;

public interface BomDAO {

	public List selectAll2(int pageNum);
	public List searchBom2(Map map);
	public List modalSearch2(String keyword);
	public List childSearch2(String itemNum);
	public int insertBom2(BomDTO bomDTO);
	public List selectDetail2(String bomNum);
	public void update2(BomDTO bomDTO);
}
