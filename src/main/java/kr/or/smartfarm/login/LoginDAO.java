package kr.or.smartfarm.login;

import java.util.List;

public interface LoginDAO {
	
	public List<LoginDTO> login();
	public LoginDTO loginCheck(LoginDTO loginDTO);

}
