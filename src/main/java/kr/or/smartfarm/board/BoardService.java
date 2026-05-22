package kr.or.smartfarm.board;

import java.util.List;

public interface BoardService {

	List<BoardDTO> getBoardList(int pageNum);
	BoardDTO getBoard(int board_num);
	
	// richtext용
	void insertBoard(BoardDTO boardDTO);
	
	// viewcnt 
	void updateViewCnt(int board_num);
	
	int updateBoard(BoardDTO boardDTO);
	int deleteBoard(BoardDTO boardDTO);
	
}
