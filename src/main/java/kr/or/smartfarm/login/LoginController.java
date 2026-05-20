package kr.or.smartfarm.login;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {
	
	@Autowired
	LoginService loginService;
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ModelAndView loginGet( ) {
		System.out.println("login 실행");
		
		
		
		ModelAndView mav = new ModelAndView("proj3Login.nohead");
		
		return mav;
		
	}
	
	@PostMapping("/login")
	@ResponseBody
	public LoginResponseDTO semiLogin(
			@RequestBody LoginDTO loginDTO, 
			HttpServletRequest request 
			) {
		
        System.out.println("login POST 실행");
		
      
        
        LoginDTO login = loginService.loginCheck( loginDTO );
				
		LoginResponseDTO response = new LoginResponseDTO();
		// 임시 로그인 검증 로직
	    if (login != null) {
	        response.setSuccess(true);
	        response.setMessage("로그인에 성공했습니다!");
	        
	        // 💡 2. [세션 처리] 로그인 성공 시 세션 객체를 가져와서 사원 정보를 저장합니다.
	        HttpSession session = request.getSession();
	        
	        // 세션에 "loginUser"라는 이름으로 로그인한 사원의 DTO(또는 사원번호)를 통째로 저장합니다.
	        session.setAttribute("loginUser", login); 
	        
	        // (선택) 세션 유지 시간 설정 - 예: 30분 동안 유지 (단위: 초)
	        session.setMaxInactiveInterval(1800); 
	        
	    } else {
	        response.setSuccess(false);
	        response.setMessage("사원번호 또는 비밀번호가 틀렸습니다.");
	    }
		
		return response;
		
	}
	
//	@RequestMapping(value = "/login", method = RequestMethod.POST)
//	public ModelAndView loginPost( LoginDTO loginDTO ) {
//		System.out.println("login 실행");
//		
//		boolean login = loginService.loginCheck( loginDTO );
//		
//		ModelAndView mav = new ModelAndView("proj3Login.nohead");
//		
//		return mav;
//		
//	}
	
	
	
	@RequestMapping("/permission")
	public String permission( Model model ) {
		
		System.out.println("permission 실행");
		
		List<LoginDTO> empList = loginService.login();
		
		model.addAttribute("empList",empList);
		
		return "content/permission.tiles";
		
	}
	
	@RequestMapping("/pdetail")
	public ModelAndView proddetail() {
		
		ModelAndView mav = new ModelAndView("prodoctiondetail.tiles");
		
		return mav;
		
	}

}
