package kr.or.smartfarm.process;

import java.util.List;
import java.util.Map;

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
		
		//목록페이지 검색
		@Override
		public List searchProcess2(Map map) {
			List result = null;
			int pageNum = (Integer)map.get("page");
			PageHelper.startPage(pageNum, 5);
			result = sqlSession.selectList("kr.or.process.searchProcess", map);
			return result;
		}
		
		//모달 셀렉트 
		@Override
		public List modalSearch2(String str) {

			System.out.println("!" + str);
			List result = sqlSession.selectList("kr.or.process.processModalSearch", str);
			System.out.println(result);
			return result;
		}
}
