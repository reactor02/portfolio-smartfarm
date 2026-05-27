package kr.or.smartfarm.process;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class ProcessDAOImpl implements ProcessDAO{

	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List selectAll2(int pageNum) {
		List result = null;
		
		PageHelper.startPage(pageNum, 5);
		result = sqlSession.selectList("kr.or.process.loadProcess");
		
		return result;
	}
	
	//디테일 셀렉트
		@Override
		public List selectDetail2(int itemNum) {
			List result = null;
			result = sqlSession.selectList("kr.or.process.PdetailSelect", itemNum);
			return result;
			
		}
}
