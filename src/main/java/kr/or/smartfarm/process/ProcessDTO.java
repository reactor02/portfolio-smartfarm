package kr.or.smartfarm.process;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

//공정
@Data
public class ProcessDTO {
	private int id;
	private int process_num; //시퀀스
	private String process_content; //공정 방법
	private int flow; //공정 순서
	private MultipartFile image; //공정 이미지
	private String savedFileName; //db에 올릴 이름
	private int head_count;
	private int item_num; //item시퀀스
	private String base64Image;
	private String process_status;
}
