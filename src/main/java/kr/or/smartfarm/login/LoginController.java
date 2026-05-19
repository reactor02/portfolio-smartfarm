package kr.or.smartfarm.login;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {
	
	@Autowired
	LoginService loginService;
	
	@RequestMapping("/login")
	public ModelAndView login() {
		
		
		
		ModelAndView mav = new ModelAndView("login.nohead");
		
		return mav;
		
	}
	
	@RequestMapping("/changepw")
	public ModelAndView changepw() {
		
		ModelAndView mav = new ModelAndView("proj3Changepw.nohead");
		
		return mav;
		
	}
	
	@RequestMapping("/permission")
	public ModelAndView permission() {
		
		List<LoginDTO> empList = loginService.login();
		
		ModelAndView mav = new ModelAndView("permission.tiles");
		
		// 3. 뷰에서 사용할 이름("empList")으로 데이터를 저장합니다.
	    mav.addObject("empList", empList); 
		
		return mav;
		
	}
	
	@RequestMapping("/pdetail")
	public ModelAndView proddetail() {
		
		ModelAndView mav = new ModelAndView("prodoctiondetail.tiles");
		
		return mav;
		
	}

}
