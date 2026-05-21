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
	
	
	
}
