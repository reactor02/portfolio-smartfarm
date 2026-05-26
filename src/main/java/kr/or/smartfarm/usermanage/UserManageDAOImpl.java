package kr.or.smartfarm.usermanage;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserManageDAOImpl implements UserManageDAO {

	@Autowired // 또는 프로젝트 설정에 따른 @SqlSession 어노테이션
	private SqlSession sqlSession;

	// 매퍼 XML의 namespace를 상수로 지정해두면 편리합니다.
	private static final String NAMESPACE = "kr.or.smartfarm.login.LoginDAO.";

	@Override
	public List<UserManageDTO> getUserManage() {
		// TODO Auto-generated method stub

		List<UserManageDTO> result = sqlSession.selectList(NAMESPACE + "getUsers");

		return result;
	}
	@Override
	public List<UserManageDTO> selectd() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = sqlSession.selectList(NAMESPACE + "selectd");
		
		return result;
	}
	@Override
	public List<UserManageDTO> selectl() {
		// TODO Auto-generated method stub
		
		List<UserManageDTO> result = sqlSession.selectList(NAMESPACE + "selectl");
		
		return result;
	}
	@Override
	public UserManageDTO getUserDetail(String userId) {
		// TODO Auto-generated method stub
		
		UserManageDTO result = sqlSession.selectOne(NAMESPACE + "getUserDetail", userId);
		
		return result;
	}

	@Override
	public UserManageDTO searchpw(UserManageDTO changepwDTO) {
		// TODO Auto-generated method stub

		UserManageDTO result = sqlSession.selectOne(NAMESPACE + "searchpw", changepwDTO);

		return result;
	}

}
