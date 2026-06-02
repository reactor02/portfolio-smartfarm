package kr.or.smartfarm.files;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FileDAO {

	@Autowired
	SqlSession sqlSession;
	
	public void insertFile(FileDTO dto) {
		sqlSession.insert("mapper.file.insertFile", dto);
	} 
	
	public List<FileDTO> findByBoardNum(int board_num){
		return sqlSession.selectList("mapper.file.findByBoardNum", board_num);
	}
}
