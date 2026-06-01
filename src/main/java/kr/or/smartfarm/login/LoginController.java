package kr.or.smartfarm.login;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {
	
	@Autowired
	LoginService loginService;
	
	@GetMapping("/login")
	public ModelAndView loginGet( ) {
		System.out.println("login Get 실행");
				
		ModelAndView mav = new ModelAndView("proj3Login.nohead");
		
		return mav;
		
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
	    // 세션의 모든 정보를 초기화합니다.
	    session.invalidate();

	    // 로그인 페이지 또는 메인 페이지로 이동합니다.
	    return "redirect:login"; 
	}
	
	@PostMapping("/login")
	@ResponseBody // 💡 반드시 필요! 자바스크립트 fetch가 이 어노테이션 덕분에 JSON을 읽을 수 있습니다.
	public LoginResponseDTO semiLogin(
	        @RequestBody LoginDTO loginDTO, // 💡 JSON 요청을 받기 위해 유지
	        HttpServletRequest request
	        ) {
	    
	    System.out.println("login POST 실행");
	    
	    LoginDTO login = loginService.loginCheck(loginDTO);
	    LoginResponseDTO response = new LoginResponseDTO();
	       
	    int permission = -1;
	    
	    
	    if (login != null) {
	    	
	    	if(login.getE_level() == 1 ) {
	    		permission = 1;
	    	} else if(login.getE_level() == 2 && login.getDept_num() == 1) {
	    		permission = 4;
	    	} else if(login.getE_level() == 2 ) {
	    		permission = 2;
	    	} else if(login.getE_level() == 3 ) {
	    		permission = 3;
	    	} 
	    	
	        // [세션 처리]
	        HttpSession session = request.getSession();
	        session.setAttribute("loginUser", login); 
	        session.setAttribute("role", permission); 
	        session.setMaxInactiveInterval(1800); 
	        
	        // 💡 자바스크립트 .then(data => { ... }) 쪽으로 성공 신호를 보냅니다.
	        response.setSuccess(true);
	        response.setMessage("로그인에 성공했습니다!");
	        
	    } else {
	        // 💡 자바스크립트 쪽으로 실패 신호와 메시지를 보냅니다.
	        response.setSuccess(false);
	        response.setMessage("사원번호 또는 비밀번호가 틀렸습니다.");
	    }
	    
	    return response; // 💡 문자열이 아닌 DTO 객체를 JSON 형태로 전송합니다.
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
