package kr.or.smartfarm.bom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BomServiceImpl implements BomService{

	@Autowired
	BomDAO bomDAO;
	
	public List selectAll(int pageNum) {
		List result = null;
		
		result = bomDAO.selectAll2(pageNum);
		return result;
	}
	
	//목록 검색 
	@Override
	public List searchBom(Map map) {
		List result = null;
		
		 result = bomDAO.searchBom2(map);
		return result;
	}
	
	//모달 부모 검색
	@Override
	public Map modalSearch(String keyword) {
		List result0 = null;
		
		result0 = bomDAO.modalSearch2(keyword);
		Map result = new HashMap();
		result.put("result", result0);
		return result;
	}
	
	//모달 자식들 검색
	@Override
	public Map childSearch(String itemNum) {
		List result0 = null;
		
		result0 = bomDAO.childSearch2(itemNum);
		Map result = new HashMap();
		result.put("childs", result0);
		return result;
	}
	
	
	//insert로직
	@Override
	public int insertBom(BomDTO bomDTO) {
		int result = 0;
		result = bomDAO.insertBom2(bomDTO);
		return result;
	}
	
	@Override
	public List selectDetail(String bomNum) {
		List result = null;
		result = bomDAO.selectDetail2(bomNum);
		return result;
	}
	
	@Override
	public void update(BomDTO bomDTO) {
		bomDAO.update2(bomDTO);
		return;
	}
	
}
