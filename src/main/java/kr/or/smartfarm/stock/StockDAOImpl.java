package kr.or.smartfarm.stock;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class StockDAOImpl implements StockDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<Map<String, Object>> selectAll2(int pageNum) {
		List result = null;
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.stock.loadStock");
		System.out.println(result);
		return result;
	}
	
	public List searchStock2(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.stock.searchStock", map);
		return result;
	}
	
	//모달 셀렉트 
	public List modalSearch2(String str) {

		System.out.println("!" + str);
		List result = sqlSession.selectList("kr.or.stock.modalSearch", str);
		System.out.println(result);
		return result;
	}
	
	public int insertStock2(StockDTO dto) {
		
		int result = sqlSession.insert("kr.or.stock.insert", dto);
		System.out.println("DAO에서 result == "+ result);
		return result;
	}
	
	//디테일 셀렉트
	public List selectDetail2(StockDTO dto) {
		List result = null;
		result = sqlSession.selectList("kr.or.stock.insert", dto);
		return result;
		
	}
}
