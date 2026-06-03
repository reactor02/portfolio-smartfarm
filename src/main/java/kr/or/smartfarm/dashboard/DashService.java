package kr.or.smartfarm.dashboard;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DashService {

		@Autowired
		DashDAO dashDAO;
		
		public List selectBoard() {
			List result = dashDAO.selectBoard();
			return result;
		}
		
		public List selectPS() {
			List result = dashDAO.selectPS();
			return result;
		}
		
		public List selectKPIPP(String period, String startDate, String endDate) {
			List result = dashDAO.selectKPIPP(period, startDate, endDate); 
			return result;
		}
		
		public List selectKPIShip(String period, String startDate, String endDate) {
			List result = dashDAO.selectKPIShip(period, startDate, endDate); 
			return result;
		}
		
		public List selectKPIDefect(String period, String startDate, String endDate) {
			List result = dashDAO.selectKPIDefect(period, startDate, endDate);
			return result;
		}
		
		public Integer selectKPIFacility() {
			return dashDAO.selectKPIFacility();
		}
		
		public Map resultDashBoard() {
			Map map = new HashMap();
			//생산관리
			map.put("resultProd", dashDAO.selectProd());
			//작업지시
			map.put("resultOrder", dashDAO.selectWork());
			return map;
		}
}
