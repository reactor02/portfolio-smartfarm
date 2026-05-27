package kr.or.smartfarm.qc;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QcServiceImpl implements QcService{

	@Autowired
	QcDAO qcDAO;

	@Override
	public List selectAll(int pageNum) {
		
		List result = new ArrayList();
		
		result = qcDAO.selectAll(pageNum);
		
		return result; 
	}

}
