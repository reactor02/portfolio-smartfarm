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
}
