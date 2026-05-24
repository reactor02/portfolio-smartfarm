package kr.or.smartfarm.bom;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;


public interface BomDAO {

	public List selectAll2(int pageNum);
	public List searchBom2(Map map);
}
