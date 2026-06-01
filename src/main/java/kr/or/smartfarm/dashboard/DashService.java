package kr.or.smartfarm.dashboard;

import java.util.List;

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
}
