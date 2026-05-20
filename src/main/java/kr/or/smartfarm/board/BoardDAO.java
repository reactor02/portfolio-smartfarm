package kr.or.smartfarm.board;

import java.util.List;

public interface BoardDAO {

	List<BoardDTO> selectAllBoard(int pageNum);
	public BoardDTO selectOneBoard(int board_num);
	
}
