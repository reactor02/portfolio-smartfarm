package kr.or.smartfarm.changepw;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.smartfarm.login.LoginDTO;
import kr.or.smartfarm.login.SHA256Util;

@Service
public class ChangepwServiceImpl implements ChangepwService {

	@Autowired
	ChangepwDAO changepwDAO;

	@Override
	public int changepw(ChangepwDTO changepwDTO) {
		// TODO Auto-generated method stub

		String pw = SHA256Util.encrypt(changepwDTO.getPw());

		changepwDTO.setPw(pw);

		int result = changepwDAO.changepw(changepwDTO);

		return result;

	}

	@Override
	public ChangepwDTO searchpw(ChangepwDTO changepwDTO) {
		
		ChangepwDTO result = changepwDAO.searchpw(changepwDTO);		
		
		if(result != null && result.getSecret().equals(changepwDTO.getSecret())) {
			return result;
		}		
		
		return null;
	}

}
