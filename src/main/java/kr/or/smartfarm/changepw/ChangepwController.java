package kr.or.smartfarm.changepw;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.smartfarm.login.LoginResponseDTO;

@Controller
public class ChangepwController {
	
	
	@Autowired
	ChangepwService changepwService;
	
	
	
	@GetMapping("/changepw")
	public String changepwGet() {
		System.out.println("changepwGet 실행");
		
		return "proj3Changepw.nohead";
		
	}
	
	@GetMapping("/searchpw")
	public String searchGet() {
		System.out.println("searchpwGet 실행");
		
		return "proj3Serchpw.nohead";
		
	}
	
	
	@PostMapping("/changepw")
	@ResponseBody
	public LoginResponseDTO searchPost( 
			@RequestBody ChangepwDTO changepwDTO, 
			HttpServletRequest request 
			) {
		
		System.out.println("searchPost 실행");
		
		ChangepwDTO searchpw = changepwService.searchpw(changepwDTO);
		
		
		LoginResponseDTO response = new LoginResponseDTO();
		// 임시 로그인 검증 로직
		if (searchpw != null) {
			response.setSuccess(true);
			response.setMessage("비밀번호가 변경되었습니다.");
			
		} else {
			response.setSuccess(false);
			response.setMessage("비밀번호변경에 실패했습니다.");
		}
		
		return response;
		
	}
	@PostMapping("/searchpw")
	@ResponseBody
	public LoginResponseDTO changepwPost( 
			@RequestBody ChangepwDTO changepwDTO, 
			HttpServletRequest request 
			) {
		
		System.out.println("changepwPost 실행");
		
		int changepw = changepwService.changepw(changepwDTO);
		
		
		LoginResponseDTO response = new LoginResponseDTO();
		// 임시 로그인 검증 로직
	    if (changepw != 0) {
	        response.setSuccess(true);
	        response.setMessage("비밀번호가 변경되었습니다.");
	       
	    } else {
	        response.setSuccess(false);
	        response.setMessage("비밀번호변경에 실패했습니다.");
	    }
		
		return response;
		
	}
	

}
