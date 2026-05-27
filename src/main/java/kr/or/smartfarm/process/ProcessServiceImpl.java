package kr.or.smartfarm.process;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


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
	
	
}
