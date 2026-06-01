package kr.or.smartfarm.changepw;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.smartfarm.login.LoginDTO;

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
	
	@PostMapping("/mpchangepw")
	@ResponseBody // 💡 자바스크립트 fetch(Ajax) 통신에 필수
	public Map<String, Object> mpchangepwPost( 
	        ChangepwDTO changepwDTO, // 💡 화면에서 넘어온 새 비밀번호(pw, pw2)가 자동으로 담깁니다.
	        HttpSession session
	        ) {
	    
	    System.out.println("mpchangepwPost 실행 (LoginDTO -> ChangepwDTO 값 복사 방식)");
	    Map<String, Object> response = new HashMap();
	    
	    // 1. [세션 추출] 세션에 들어있는 실제 타입인 LoginDTO로 안전하게 꺼냅니다. (ClassCastException 원천 차단)
	    LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
	    
	    // 2. [검증] 세션 만료 및 로그인 유무 확인
	    if (loginUser == null) {
	        response.put("success", false);
	        response.put("message", "인증 시간이 만료되었거나 잘못된 접근입니다.");
	        return response; 
	    }
	    
	    /* ==========================================
	     * 💡 [핵심] LoginDTO -> ChangepwDTO 데이터 이행(복사)
	     * ========================================== */
	    changepwDTO.setEmp_num(loginUser.getEmp_num()); // 가장 중요한 사원번호 주입
	    changepwDTO.setEname(loginUser.getEname());
	    changepwDTO.setE_level(String.valueOf(loginUser.getE_level())); // int -> String 변환
	    changepwDTO.setTel(loginUser.getTel());
	    changepwDTO.setHire_date(loginUser.getHire_date());
	    changepwDTO.setStatus(loginUser.getStatus());
	    changepwDTO.setTermination_date(loginUser.getTermination_date());
	    changepwDTO.setSecret(loginUser.getSecret());
	    changepwDTO.setDept_num(String.valueOf(loginUser.getDept_num())); // int -> String 변환

	    // 3. [비즈니스 로직] 모든 세션 값이 채워진 changepwDTO로 기존 서비스 호출! (에러 없음)
	    int changepw = changepwService.changepw(changepwDTO);
	    
	    // 4. [결과 반환] 자바스크립트 fetch가 읽을 수 있도록 성공/실패 JSON 메시지 리턴
	    if (changepw != 0) {
	        response.put("success", true);
	        response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
	        session.removeAttribute("verifiedUser"); // 본인인증 세션 제거
	    } else {
	        response.put("success", false);
	        response.put("message", "비밀번호 변경에 실패했습니다. 기존 비밀번호와 같거나 정보가 다릅니다.");
	    }
	    
	    return response; 
	}
	

}
