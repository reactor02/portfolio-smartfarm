package kr.or.smartfarm.board;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardMapper {

	void insert(BoardDTO boardDTO);
	
	BoardDTO findById(int board_num);
}
