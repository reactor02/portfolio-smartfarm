package kr.or.smartfarm.files;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileService {
	
	@Autowired 
	FileDAO fileDAO; 
	
	public void save(MultipartFile file, int board_num) {
		
		try {
			// 1. 원본 파일명 
			String originalName = file.getOriginalFilename(); 
			
			// 2. 저장용 파일명(중복 방지)
			String savedName = System.currentTimeMillis() + "_" + originalName; 
			
			// 3. 저장 경로
			String uploadPath = "C:/upload/";
			
			File dest = new File(uploadPath + savedName);
			
			// 4. 실제 파일 저장
			file.transferTo(dest);
			
			// 5. DB 저장 
			FileDTO dto = new FileDTO();
			dto.setFile_name(savedName);
			dto.setBoard_num(board_num);
			
			fileDAO.insertFile(dto);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	// 게시글별 파일 조회 
	public List<FileDTO> getFiles(int board_num){
		return fileDAO.findByBoardNum(board_num);
	}
	
}
