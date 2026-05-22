package kr.or.smartfarm.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired 
	BoardDAO boardDAO;

	@Override
	public List<BoardDTO> getBoardList(int pageNum) {
		List<BoardDTO> result = boardDAO.selectAllBoard(pageNum);
		return result;
	}

	@Override
	public BoardDTO getBoard(int board_num) {
		BoardDTO boardDTO = boardDAO.selectOneBoard(board_num);
		return boardDTO;
	}

	@Override
	public void insertBoard(BoardDTO boardDTO) {
		boardDAO.insertBoard(boardDTO);
		
	}

	@Override
	public void updateViewCnt(int board_num) {
		boardDAO.updateViewCnt(board_num);
		
	}

	@Override
	public int updateBoard(BoardDTO boardDTO) {
		int result = -1; 
		
		result = boardDAO.updateBoard(boardDTO);
		return result;
	}

	@Override
	public int deleteBoard(BoardDTO boardDTO) {
		int result = -1; 
		
		result = boardDAO.deleteBoard(boardDTO);
		return result;
	}

	@Override
	public BoardDTO findById(int board_num) {
		BoardDTO boardDTO = null;
		boardDTO = boardDAO.findById(board_num);
		return boardDTO;
	}
	
	
	
}
