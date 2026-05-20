package kr.or.smartfarm.changepw;

import lombok.Data;

@Data
public class LoginResponseDTO {
	
	  private boolean success; // 💡 true면 성공, false면 실패
	    private String message;  // 💡 화면에 띄워줄 알림 문구

}
