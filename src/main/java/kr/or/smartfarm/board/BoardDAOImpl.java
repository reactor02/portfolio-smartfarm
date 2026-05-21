package kr.or.smartfarm.board;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class BoardDAOImpl implements BoardDAO {

	@Autowired 
	SqlSession sqlSession;

	@Override
	public List<BoardDTO> selectAllBoard(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		
		List<BoardDTO> resultList = null; 
		
		resultList = sqlSession.selectList("mapper.board.selectBoard");
		System.out.println("dao : resultList: " + resultList);
		
		return resultList;
	}

	@Override
	public BoardDTO selectOneBoard(int board_num) {
		BoardDTO boardDTO = null;
		
		boardDTO = sqlSession.selectOne("mapper.board.selectOneBoard", board_num);
		System.out.println("selectOneBoard: BoardDTO: " + boardDTO);
		return boardDTO;
	}

	@Override
	public void insertBoard(BoardDTO boardDTO) {
		
		sqlSession.insert("mapper.board.insertBoard", boardDTO);
		
	}

	@Override
	public void updateViewCnt(int board_num) {
		sqlSession.update("mapper.board.updateViewCnt", board_num);
		
	}
	
}
