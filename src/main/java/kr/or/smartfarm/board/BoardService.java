package kr.or.smartfarm.board;

import java.util.List;
import java.util.Map;

public interface BoardService {

	List<BoardDTO> getBoardList(int pageNum);
	BoardDTO getBoard(int board_num);
	
	// richtext용
	void insertBoard(BoardDTO boardDTO);
	
	// viewcnt 
	void updateViewCnt(int board_num);
	
	// 아이디로 찾기
	BoardDTO findById(int board_num);
	
	int updateBoard(BoardDTO boardDTO);
	int deleteBoard(BoardDTO boardDTO);
	
	// 검색용
	List<BoardDTO> search(Map map);
	
}
