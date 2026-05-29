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
}
