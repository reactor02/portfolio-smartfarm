package kr.or.smartfarm.process;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.smartfarm.stock.StockDTO;


@Service
public class ProcessServiceImpl implements ProcessService{

	@Autowired
	ProcessDAO DAO;
	
	public List selectAll(int pageNum) {
		List result = null;
		
		result = DAO.selectAll2(pageNum);
		return result;
	}
	
	@Override
	public List selectDetail(int itemNum) {
		List result = null;
		result = DAO.selectDetail2(itemNum);
		return result;
	}
	
	//목록 검색 
	@Override
	public List searchProcess(Map map) {
		List result = null;
		
		 result = DAO.searchProcess2(map);
		return result;
	}
	@Override
	public Map modalSearch(String str) {
		Map result = new HashMap();
		List result2 = DAO.modalSearch2(str);
		result.put("result", result2);
		return result;
	}
	@Override
	public int insertProcess(ProcessDTO dto) {
		int result = 0;
		result = DAO.insertProcess2(dto);
	return result;
	}
	
	@Override
	 public void updateStatus(ProcessDTO dto) {
		DAO. updateStatus2(dto);
		return;
	}
}
