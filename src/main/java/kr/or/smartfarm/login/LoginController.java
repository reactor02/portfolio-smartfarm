package kr.or.smartfarm.login;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import kr.or.smartfarm.login.LoginDTO;
import kr.or.smartfarm.login.LoginService;

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
