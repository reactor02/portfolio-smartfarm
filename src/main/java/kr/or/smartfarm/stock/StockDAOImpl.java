package kr.or.smartfarm.stock;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StockDAOImpl implements StockDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List selectAll2() {
		List result = null;
		result = sqlSession.selectList("mapper.stock.loadStock");
		
		return result;
	}
}
