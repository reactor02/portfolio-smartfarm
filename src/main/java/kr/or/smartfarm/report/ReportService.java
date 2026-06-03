package kr.or.smartfarm.report;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReportService {

	@Autowired
	ReportDAO reportDAO;
	
	public List selectAll() {
		
		List result = reportDAO.selectAll();
		
		return result;
	}
	
	public List selectQc() {
		List result = reportDAO.selectQc();
		return result;
	}
	
	public List selectIO() {
		List result = reportDAO.selectIO();
		return result;
	}
	
	public List selectProc() {
		List result = reportDAO.selectProc();
		return result;
	}
	
	public List selectDefective() {
		List result = reportDAO.selectDefective();
		return result;
	}
	
	public List selectEquip() {
		List result = reportDAO.selectEquip();
		return result;
	}
	
	public List selectFM() {
		List result = reportDAO.selectFM();
		return result;
	}
}
