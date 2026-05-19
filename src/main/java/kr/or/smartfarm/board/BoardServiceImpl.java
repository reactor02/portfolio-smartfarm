package kr.or.smartfarm.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired 
	BoardDAO boardDAO;

	@Override
	public List<BoardDTO> getBoardList() {
		List<BoardDTO> result = boardDAO.selectAllBoard();
		return result;
	}
	
	
	
}
