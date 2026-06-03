package kr.or.smartfarm.codemanage;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class CodeManageDAOImpl implements CodeManageDAO {

	@Autowired // 또는 프로젝트 설정에 따른 @SqlSession 어노테이션
	private SqlSession sqlSession;

	// 매퍼 XML의 namespace를 상수로 지정해두면 편리합니다.
	private static final String NAMESPACE = "kr.or.smartfarm.codemanage.CodeManageDAO.";

	@Override
	public List<CodeManageDTO> getCodeManage(int page) {
		// TODO Auto-generated method stub
		
		// 1. ⭐ 핵심: 회원 목록 조회 직전에 딱 5개씩만 가져오도록 PageHelper 세팅
	    // (현재페이지번호, 한 페이지에 보여줄 데이터 개수)
	    PageHelper.startPage(page, 5);

		List<CodeManageDTO> result = sqlSession.selectList(NAMESPACE + "getCodes");

		return result;
	}
	@Override
	public List<CodeManageDTO> getCodeSearch(CodeManageDTO searchDTO) {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = sqlSession.selectList(NAMESPACE + "CodeSearch", searchDTO);
		
		return result;
	}
	@Override
	public int CodeInsert(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
		int result = sqlSession.insert(NAMESPACE + "CodeInsert", CodeManageDTO);
		
		return result;
	}
	@Override
	public int CodeUpdate(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
		int result = sqlSession.insert(NAMESPACE + "CodeUpdate", CodeManageDTO);
		
		return result;
	}
	@Override
	public int CodeRetire(int itemNum) {
		// TODO Auto-generated method stub
		
		int result = sqlSession.insert(NAMESPACE + "CodeRetire", itemNum);
		
		return result;
	}
	@Override
	public int CodeLevelUpdate(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
		int result = sqlSession.insert(NAMESPACE + "CodeLevelUpdate", CodeManageDTO);
		
		return result;
	}
	@Override
	public CodeManageDTO getCodeDetail(String CodeId) {
		// TODO Auto-generated method stub
		
		CodeManageDTO result = sqlSession.selectOne(NAMESPACE + "getCodeDetail", CodeId);
		
		return result;
	}

	@Override
	public CodeManageDTO searchpw(CodeManageDTO changepwDTO) {
		// TODO Auto-generated method stub

		CodeManageDTO result = sqlSession.selectOne(NAMESPACE + "searchpw", changepwDTO);

		return result;
	}
	
	
	
	
	

	@Override
	public List<CodeManageDTO> selectl() {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = sqlSession.selectList(NAMESPACE + "selectl");
		
		return result;
	}
	@Override
	public List<CodeManageDTO> selectd() {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = sqlSession.selectList(NAMESPACE + "selectd");
		
		return result;
	}
	@Override
	public List<CodeManageDTO> selectm() {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = sqlSession.selectList(NAMESPACE + "selectm");
		
		return result;
	}
}
