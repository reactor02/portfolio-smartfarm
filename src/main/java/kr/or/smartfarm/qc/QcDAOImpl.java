package kr.or.smartfarm.qc;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class QcDAOImpl implements QcDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<QcDTO> selectAll(int pageNum) {
		
		PageHelper.startPage(pageNum, 5);
		
		List<QcDTO> result = sqlSession.selectList("mapper.qc.selectAllQc");
		
		return result;
	}
	
}
