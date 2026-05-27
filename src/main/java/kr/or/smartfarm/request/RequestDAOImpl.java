package kr.or.smartfarm.request;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class RequestDAOImpl implements RequestDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List selectAll(int pageNum) {
		List result = null;
		
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.smartfarm.request.loadRequest");
		
		return result;
	}
	
	@Override
	public List searchRequest(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.smartfarm.request.searchRequest", map);
		return result;
	}

	@Override
	public List searchVender(String keyword) {
		return sqlSession.selectList("kr.or.smartfarm.request.searchVender", keyword);
	}

	@Override
	public List loadItems() {
		return sqlSession.selectList("kr.or.smartfarm.request.loadItems");
	}

	@Override
	public List loadProducts() {
		return sqlSession.selectList("kr.or.smartfarm.request.loadProducts");
	}

	@Override
	public int insertRequest(Map map) {
		return sqlSession.insert("kr.or.smartfarm.request.insertRequest", map);
	}

}
