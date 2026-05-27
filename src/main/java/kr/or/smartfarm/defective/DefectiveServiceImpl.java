package kr.or.smartfarm.defective;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DefectiveServiceImpl implements DefectiveService{

	@Autowired
	DefectiveDAO defectiveDAO;

	@Override
	public List selectAll(int pageNum) {
		
		List result = new ArrayList();
		
		result = defectiveDAO.selectAll(pageNum);
		
		return result; 
	}

}
