package kr.or.smartfarm.comment;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CommentDAO {

	@Autowired
	SqlSession sqlSession;
	
	public List<CommentDTO> selectAll(int board_num){
		
		List<CommentDTO> resultList = null; 
		
		resultList = sqlSession.selectList("mapper.comment.selectComment", board_num);
		System.out.println("dao: resultList: " + resultList);
		
		return resultList;
	}
	
	public int insertComment(CommentDTO cmtDTO) {
		int result = -1; 
		
		result = sqlSession.insert("mapper.comment.insertComment", cmtDTO);
		return result;
	}
	
	public int deleteComment(CommentDTO cmtDTO) {
		int result = -1; 
		
		result = sqlSession.delete("mapper.comment.deleteComment", cmtDTO);
		return result;
	}
	
	
}
