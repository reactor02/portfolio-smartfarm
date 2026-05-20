package kr.or.smartfarm.changepw;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChangepwServiceImpl implements ChangepwService{
	
	
	
	@Autowired
	ChangepwDAO loginDAO;
	
	public List<ChangepwDTO>  changepw() {
		
		
		List<ChangepwDTO> result = loginDAO.changepw();
			
		
		return result;
		
		
	}

}
