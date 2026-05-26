package kr.or.smartfarm.usermanage;

import java.util.List;

public interface UserManageDAO {
	
	public List<UserManageDTO> getUserManage();
	public List<UserManageDTO> selectd();
	public List<UserManageDTO> selectl();
	public UserManageDTO getUserDetail(String userId);
	public UserManageDTO searchpw(UserManageDTO changepwDTO);

}
