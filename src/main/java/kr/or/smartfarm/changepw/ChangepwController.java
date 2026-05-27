package kr.or.smartfarm.changepw;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

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
			 ChangepwDTO changepwDTO, 
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
			return "proj3Searchpw.nohead"; 
		}
		
	}
	@PostMapping("/changepw")
	public String changepwPost( 
	        ChangepwDTO changepwDTO, 
	        HttpSession session,
	        Model model // 💡 리다이렉트가 아니므로 Model을 사용하여 데이터를 전달합니다.
	        ) {
	    
	    System.out.println("changepwPost 실행");
	    
	    // 1. 세션에서 인증 유저 정보 꺼내기
	    ChangepwDTO verifiedUser = (ChangepwDTO) session.getAttribute("verifiedUser");
	    
	    // 2. 보안 검증: 세션 만료 시 처리
	    if (verifiedUser == null) {
	        model.addAttribute("message", "인증 시간이 만료되었거나 잘못된 접근입니다.");
	        model.addAttribute("success", false);
	        // 필요 시 본인인증 화면의 Tiles 설정값을 리턴하세요.
	        return "proj3Searchpw.nohead"; 
	    }
	    
	    // 3. 세션 ID 세팅 및 비밀번호 변경 실행
	    changepwDTO.setEmp_num(verifiedUser.getEmp_num());
	    int changepw = changepwService.changepw(changepwDTO);
	    
	    // 4. 결과에 따른 데이터 적재 및 Tiles 정의 이름(Definition Name) 리턴
	    if (changepw != 0) {
	        // [조건 1] 결과 데이터 모델에 담기
	        model.addAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
	        model.addAttribute("success", true);
	        
	        session.removeAttribute("verifiedUser"); // 세션 정리
	        
	        // [조건 2] 로그인 화면에 해당하는 Tiles 정의(Definition) 이름 리턴
	        // 💡 프로젝트의 tiles.xml에 등록된 로그인 화면 이름으로 적어주세요 (예: "login.nohead" 등)
	        return "login.nohead"; 
	       
	    } else {
	        model.addAttribute("message", "비밀번호 변경에 실패했습니다. 다시 시도해주세요.");
	        model.addAttribute("success", false);
	        
	        // 실패 시 현재 비밀번호 변경 화면의 Tiles 정의 이름 리턴
	        return "proj3Changepw.nohead"; 
	    }
	}
	

}
