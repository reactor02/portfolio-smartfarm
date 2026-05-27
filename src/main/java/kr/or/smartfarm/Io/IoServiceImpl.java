package kr.or.smartfarm.io;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class IoServiceImpl implements IoService{
	
	@Autowired
	IoDAO ioDAO;

	@Override
	public List selectAll(int pageNum) {
		List result = null;
		
		result = ioDAO.selectAll2(pageNum);
		return result;
	}
	
	public List searchIo(Map map) {
		List result = null;
		
		 result = ioDAO.searchIo2(map);
		return result;
	}
	
	public List facility() {
		List facilityList = null;
		facilityList = ioDAO.facility2();
		return facilityList; 
	}
	
	public List modalSearch(String keyword) {
		List result = null;
		
		return result;
	}
}
