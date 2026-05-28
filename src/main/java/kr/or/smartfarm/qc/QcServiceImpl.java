package kr.or.smartfarm.qc;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

	@Override
	public List selectItem() {
		return qcDAO.selectItem();
	}

	@Override
	public List searchQc(Map map) {
		return qcDAO.searchQc(map);
	}

	@Override
	public List selectWaiting() {
		return qcDAO.selectWaiting();
	}

	@Override
	public QcDTO selectDetail(int io_num) {
		return qcDAO.selectDetail(io_num);
	}

}
