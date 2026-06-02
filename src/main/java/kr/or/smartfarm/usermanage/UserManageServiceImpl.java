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
	public List<UserManageDTO> getUserManage(int pageNum) {
		// TODO Auto-generated method stub

		List<UserManageDTO> result = userManageDAO.getUserManage(pageNum);

		return result;

	}
	@Override
	public List<UserManageDTO> getUserSearch(UserManageDTO searchDTO) {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = userManageDAO.getUserSearch(searchDTO);
		
		return result;
		
	}
	@Override
	public List<UserManageDTO> selectd() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = userManageDAO.selectd();
		
		return result;
		
	}
	@Override
	public List<UserManageDTO> selectm() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = userManageDAO.selectm();
		
		return result;
		
	}
	@Override
	public List<UserManageDTO> selectw() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = userManageDAO.selectw();
		
		return result;
		
	}
	@Override
	public int userInsert(UserManageDTO userManageDTO) {
		// TODO Auto-generated method stub
		
        String pw = SHA256Util.encrypt(userManageDTO.getPw());
		
        userManageDTO.setPw(pw);
		
		int result = userManageDAO.userInsert(userManageDTO);
		
		return result;
		
	}
	@Override
	public int userUpdate(UserManageDTO userManageDTO) {
		// TODO Auto-generated method stub
		
		int result = userManageDAO.userUpdate(userManageDTO);
		
		return result;
		
	}
	@Override
	public int userRetire(UserManageDTO userManageDTO) {
		// TODO Auto-generated method stub
		
		int result = userManageDAO.userRetire(userManageDTO);
		
		return result;
		
	}
	@Override
	public int userLevelUpdate(UserManageDTO userManageDTO) {
		// TODO Auto-generated method stub
		
		int result = userManageDAO.userLevelUpdate(userManageDTO);
		
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
