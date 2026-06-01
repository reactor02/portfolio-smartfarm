package kr.or.smartfarm.dashboard;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DashDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<DashDTO> selectBoard(){
		List<DashDTO> result = sqlSession.selectList("mapper.dash.getBoardList");
		return result;
	}
	
	
}
