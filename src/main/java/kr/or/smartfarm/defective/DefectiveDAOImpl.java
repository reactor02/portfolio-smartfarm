package kr.or.smartfarm.defective;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class DefectiveDAOImpl implements DefectiveDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<DefectiveDTO> selectAll(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		
		List<DefectiveDTO> result = sqlSession.selectList("mapper.defective.selectAllDefective");
		
		return result;
	}
	
}
