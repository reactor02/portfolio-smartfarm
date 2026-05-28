package kr.or.smartfarm.usermanage;

import java.util.List;

public interface UserManageService {
	
	public List<UserManageDTO> getUserManage();
	public List<UserManageDTO> getUserSearch(UserManageDTO searchDTO);
	public List<UserManageDTO> selectd();
	public List<UserManageDTO> selectl();
	public List<UserManageDTO> selectm();
	public int userInsert(UserManageDTO userManageDTO);
	public int userUpdate(UserManageDTO userManageDTO);
	public int userRetire(UserManageDTO userManageDTO);
	public int userLevelUpdate(UserManageDTO userManageDTO);
	public UserManageDTO getUserDetail(String userId);
	public UserManageDTO searchpw(UserManageDTO changepwDTO);

}
