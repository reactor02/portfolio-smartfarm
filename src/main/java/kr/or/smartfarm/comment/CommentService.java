package kr.or.smartfarm.comment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommentService {

	@Autowired
	CommentDAO commentDAO;
	
	public List<CommentDTO> selectList(int board_num){
		return commentDAO.selectAll(board_num);
	}
	
	public int writeComment(CommentDTO commentDTO) {
		return commentDAO.insertComment(commentDTO);
	}
	
	public int removeComment(CommentDTO commentDTO) {
		return commentDAO.deleteComment(commentDTO);
	}
	
}
