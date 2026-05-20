package kr.or.smartfarm.changepw;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChangepwDAOImpl implements ChangepwDAO {

	@Autowired // 또는 프로젝트 설정에 따른 @SqlSession 어노테이션
	private SqlSession sqlSession;

	// 매퍼 XML의 namespace를 상수로 지정해두면 편리합니다.
	private static final String NAMESPACE = "kr.or.smartfarm.login.LoginDAO.";

	@Override
	public int changepw(ChangepwDTO changepwDTO) {
		// TODO Auto-generated method stub

		int result = sqlSession.update(NAMESPACE + "changepw", changepwDTO);

		return result;
	}

	@Override
	public ChangepwDTO searchpw(ChangepwDTO changepwDTO) {
		// TODO Auto-generated method stub

		ChangepwDTO result = sqlSession.selectOne(NAMESPACE + "searchpw", changepwDTO);

		return result;
	}

}
