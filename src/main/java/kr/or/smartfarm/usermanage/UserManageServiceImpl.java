package kr.or.smartfarm.usermanage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.smartfarm.login.LoginDTO;
import kr.or.smartfarm.login.SHA256Util;

@Service
public class UserManageServiceImpl implements UserManageService {

	@Autowired
	UserManageDAO userManageDAO;

	@Override
	public List<UserManageDTO> getUserManage() {
		// TODO Auto-generated method stub

		List<UserManageDTO> result = userManageDAO.getUserManage();

		return result;

	}
	@Override
	public List<UserManageDTO> selectd() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = userManageDAO.selectd();
		
		return result;
		
	}
	@Override
	public List<UserManageDTO> selectl() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = userManageDAO.selectl();
		
		return result;
		
	}
	@Override
	public UserManageDTO getUserDetail(String userId) {
		// TODO Auto-generated method stub
		
		UserManageDTO result = userManageDAO.getUserDetail(userId);
		
		return result;
		
	}

	@Override
	public UserManageDTO searchpw(UserManageDTO changepwDTO) {
		
		UserManageDTO result = userManageDAO.searchpw(changepwDTO);		
		
		if(result != null && result.getSecret().equals(changepwDTO.getSecret())) {
			return result;
		}		
		
		return null;
	}

}
