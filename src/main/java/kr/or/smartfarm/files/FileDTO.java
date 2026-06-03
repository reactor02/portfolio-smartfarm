package kr.or.smartfarm.files;

import lombok.Data;

@Data
public class FileDTO {

		private Integer files_num;
		private String file_name; 
		private int board_num; 
		private String uploaded_at; 
}
