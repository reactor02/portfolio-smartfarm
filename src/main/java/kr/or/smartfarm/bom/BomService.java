package kr.or.smartfarm.bom;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;


public interface BomService {

	public List selectAll(int pageNum);
	public List searchBom(Map map);
	public Map modalSearch(String keyword);
	public Map childSearch(String itemNum);
	public int insertBom(BomDTO bomDTO);
	public List selectDetail(String bomNum);
	public void update(BomDTO bomDTO);
}
