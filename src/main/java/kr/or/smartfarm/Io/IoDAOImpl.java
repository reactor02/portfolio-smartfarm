package kr.or.smartfarm.io;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class IoDAOImpl implements IoDAO{
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List selectAll2(int pageNum) {
		List result = null;
		
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.io.loadIo");
		return result;
	}
	
	//목록페이지 검색
	@Override
	public List searchIo2(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.io.searchIo", map);
		return result;
	}
	
	@Override
	public List facility2() {
		List facility2 = null;
		facility2 = sqlSession.selectList("kr.or.io.facility");
		return facility2;
	}
	
	@Override
	public List modalSearch2(String keyword){
		List result = null;
		result = sqlSession.selectList("kr.or.io.ioModalSearch", keyword);
		
		return result;
	}
	
}
