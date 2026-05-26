package kr.or.smartfarm.bom;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class BomDAOImpl implements BomDAO{

	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List selectAll2(int pageNum) {
		List result = null;
		
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.bom.loadBom");
		
		return result;
	}
	
	//목록페이지 검색
	@Override
	public List searchBom2(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.bom.searchBom", map);
		return result;
	}
	
	//모달 부모 검색
	@Override
	public List modalSearch2(String keyword){
		List result = null;
		result = sqlSession.selectList("kr.or.bom.bomModalSearch", keyword);
		
		return result;
	}
	
	
	//모달 자식들 검색
	@Override
	public List childSearch2(String itemNum){
		List result = null;
		result = sqlSession.selectList("kr.or.bom.childSearch", itemNum);
		
		return result;
	}
	
	//insert로직
	@Override
	public int insertBom2(BomDTO bomDTO) {
		int result = 0;
		result = sqlSession.insert("kr.or.bom.bomInsert", bomDTO);
		return result;
	}
	
	//디테일 셀렉트
	public List selectDetail2(String bomNum) {
		List result = null;
		result = sqlSession.selectList("kr.or.bom.detailSelect", bomNum);
		return result;
		
	}
	
	
	//status 수정
	@Override
	public void update2(BomDTO bomDTO) {
		sqlSession.update("kr.or.bom.updateBomStatus", bomDTO);
		return;
	}
}
