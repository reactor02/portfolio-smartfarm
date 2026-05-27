package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RequestSerivceImpl implements RequestService {
	@Autowired
	RequestDAO requestDAO;
	
	public List selectAll(int pageNum) {
		List result = null;
		
		result = requestDAO.selectAll(pageNum);
		return result;
	}
	
	//목록 검색
	@Override
	public List searchBom(Map map) {
		List result = null;

		 result = requestDAO.searchRequest(map);
		return result;
	}

	@Override
	public List searchVender(String keyword) {
		return requestDAO.searchVender(keyword);
	}

	@Override
	public List loadItems() {
		return requestDAO.loadItems();
	}

	@Override
	public int insertRequest(Map map) {
		return requestDAO.insertRequest(map);
	}
}
