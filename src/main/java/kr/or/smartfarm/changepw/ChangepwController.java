package kr.or.smartfarm.changepw;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
		
		return "proj3Searchpw.nohead";
		
	}
	
	
	@PostMapping("/searchpw")
	public String searchPost( 
			@RequestBody ChangepwDTO changepwDTO, 
			 HttpSession session 
			) {
		
		System.out.println("searchPost 실행");
		
		ChangepwDTO searchpw = changepwService.searchpw(changepwDTO);
		
		
		
		// 임시 로그인 검증 로직
		if (searchpw != null) {
			System.out.println("본인확인에 성공했습니다.");
			  // 1. 세션에 사용자 정보 저장 -> JSP에서 ${sessionScope.verifiedUser}로 접근 가능
	        session.setAttribute("verifiedUser", searchpw); 
	        
	        // 2. 비밀번호 변경 페이지(JSP)를 보여주는 URL로 리다이렉트 이동
	        return "proj3Changepw.nohead"; 
			
		} else {
			System.out.println("본인확인에 실패했습니다.");
			// 1. 세션에 사용자 정보 저장 -> JSP에서 ${sessionScope.verifiedUser}로 접근 가능
			session.setAttribute("verifiedUser", searchpw); 
			
			// 2. 비밀번호 변경 페이지(JSP)를 보여주는 URL로 리다이렉트 이동
			return "proj3Changepw.nohead"; 
		}
		
	}
	@PostMapping("/changepw")
	@ResponseBody // 프론트에서 Ajax(fetch, axios)로 처리 중이라면 유지, Form 태그라면 제거 후 return "redirect:/login";
	public LoginResponseDTO changepwPost( 
	        @RequestBody ChangepwDTO changepwDTO, 
	        HttpSession session // 1. HttpServletRequest 대신 HttpSession 직접 주입
	        ) {
	    
	    System.out.println("changepwPost 실행");
	    
	    LoginResponseDTO response = new LoginResponseDTO();
	    
	    // 2. 세션에서 이전 단계(searchpw)에서 저장한 인증 유저 정보 꺼내기
	    // (이전 단계에서 세션에 객체를 통째로 넣었는지, ID 문자열만 넣었는지에 따라 형변환 하세요)
	    ChangepwDTO verifiedUser = (ChangepwDTO) session.getAttribute("verifiedUser");
	    
	    // 3. 보안 검증: 세션이 만료되었거나 비정상적인 접근인 경우 차단
	    if (verifiedUser == null) {
	        response.setSuccess(false);
	        response.setMessage("인증 시간이 만료되었거나 잘못된 접근입니다.");
	        return response;
	    }
	    
	    // 4. 세션에서 꺼낸 유저 ID를 DTO에 확실히 세팅 (프론트가 조작하지 못하도록 방어)
	    changepwDTO.setEmp_num(verifiedUser.getEmp_num());
	    
	    int changepw = changepwService.changepw(changepwDTO);
	    
	    if (changepw != 0) {
	        response.setSuccess(true);
	        response.setMessage("비밀번호가 변경되었습니다.");
	        
	        // 5. 핵심: 비밀번호 변경이 끝났으므로 본인확인 세션 완전히 제거
	        session.removeAttribute("verifiedUser");
	       
	    } else {
	        response.setSuccess(false);
	        response.setMessage("비밀번호 변경에 실패했습니다.");
	    }
	    
	    return response;
	}
	

}
