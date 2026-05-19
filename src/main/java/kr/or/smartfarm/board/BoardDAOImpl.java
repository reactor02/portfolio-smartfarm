package kr.or.smartfarm.board;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAOImpl implements BoardDAO {

	@Autowired 
	SqlSession sqlSession;

	@Override
	public List<BoardDTO> selectAllBoard() {
		
		List<BoardDTO> resultList = null; 
		
		resultList = sqlSession.selectList("mapper.board.selectBoard");
		System.out.println("dao : resultList: " + resultList);
		
		return resultList;
	}
	
}
