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
	
	@Override
	public List searchBom2(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.bom.searchBom", map);
		return result;
	}
}
