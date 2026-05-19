package kr.or.smartfarm.vender;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VenderDAOImpl implements VenderDAO{
	
	@Autowired
	SqlSession sqlSession;

	@Override 
	public List<VenderDTO> selectAllVender() {
		
		List<VenderDTO> resultList = null;
		resultList = sqlSession.selectList("mapper.vender.selectVender");
		System.out.println("dao: resultList: " + resultList);
		
		return resultList;
	}

}
