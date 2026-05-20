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
	
	

	@Override
	public LoginDTO loginCheck( LoginDTO loginDTO ) {
		// TODO Auto-generated method stub		
		String pw = SHA256Util.encrypt(loginDTO.getPw());
				
		LoginDTO result = loginDAO.loginCheck(loginDTO);		
		
		if(result != null && result.getPw().equals(pw)) {
			return result;
		}		
		
		return null;
	}

}
