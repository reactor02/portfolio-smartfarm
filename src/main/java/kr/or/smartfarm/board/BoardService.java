package kr.or.smartfarm.board;

import java.util.List;

public interface BoardService {

	List<BoardDTO> getBoardList(int pageNum);
	BoardDTO getBoard(int board_num);
}
