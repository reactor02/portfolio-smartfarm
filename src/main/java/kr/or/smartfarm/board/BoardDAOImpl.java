package kr.or.smartfarm.board;

import java.util.List;
import java.util.Map;

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

	@Override
	public int updateBoard(BoardDTO boardDTO) {
		int result = -1; 
		
		result = sqlSession.update("mapper.board.updateBoard", boardDTO);
		
		return result;
	}

	@Override
	public int deleteBoard(BoardDTO boardDTO) {
		int result = -1;
		
		result = sqlSession.delete("mapper.board.deleteBoard", boardDTO);
		return result;
	}

	@Override
	public BoardDTO findById(int board_num) {
		BoardDTO boardDTO = null;
		boardDTO = sqlSession.selectOne("mapper.board.findById", board_num);
		return boardDTO;
	}

	@Override
	public List<BoardDTO> search(Map map) {
		List resultList = null; 
		
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 10);
		resultList = sqlSession.selectList("mapper.board.searchBoard", map);
		System.out.println("search : resultList : " + resultList);
		return resultList;
	}
	
}
