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

	@Override
	public List selectLog(int io_num) {
		return qcDAO.selectLog(io_num);
	}
	@Override
	public List selectAllQc() {
		return qcDAO.selectAllQc();
	}

	@Override
	public int insertQc1(QcDTO qcDTO, Integer total_qty) {
		qcDTO.setIo_qty(total_qty);
		return qcDAO.insertQc1(qcDTO);
	}
	@Override
	public int insertQc2(QcDTO qcDTO) {
		return qcDAO.insertQc2(qcDTO);
	}

	@Override
	public QcDTO qcChk(int qc_num) {
		return qcDAO.qcChk(qc_num);
	}

	@Override
	public QcDTO crrnt_qty(QcDTO qcDTO) {
		return qcDAO.crrnt_qty(qcDTO);
	}
	
	@Override
	public int insertDefect(QcDTO qcDTO) {
		return qcDAO.insertDefect(qcDTO);
	}
	@Override
	public List selectEmp() {
		return qcDAO.selectEmp();
	}

}
