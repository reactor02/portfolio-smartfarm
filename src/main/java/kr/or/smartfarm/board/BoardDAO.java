package kr.or.smartfarm.board;

import java.util.List;

public interface BoardDAO {

	List<BoardDTO> selectAllBoard(int pageNum);
	public BoardDTO selectOneBoard(int board_num);
	
	// richtext용 
	void insertBoard(BoardDTO boardDTO);
	
	// viewcnt 업데이트 
	void updateViewCnt(int board_num);
	
	int updateBoard(BoardDTO boardDTO);
	int deleteBoard(BoardDTO boardDTO);
	
}
