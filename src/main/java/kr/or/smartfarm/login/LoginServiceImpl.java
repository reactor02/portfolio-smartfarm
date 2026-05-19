package kr.or.smartfarm.login;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginServiceImpl implements LoginService{
	
	
	
	@Autowired
	LoginDAO loginDAO;
	
	public List<LoginDTO> login() {
		
		
		List<LoginDTO> result = loginDAO.login();
			
		
		return result;
		
		
	}

}
