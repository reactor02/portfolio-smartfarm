package kr.or.smartfarm.changepw;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import kr.or.smartfarm.login.LoginDTO;
import kr.or.smartfarm.login.LoginService;

@Controller
public class ChangepwController {
	
	
	@Autowired
	ChangepwService changepwService;
	
	
	
	
	
	
	@RequestMapping("/changepw")
	public String changepw( Model model ) {
		
		System.out.println("changepw 실행");
		
		List<ChangepwDTO> empList = changepwService.changepw();
		
		model.addAttribute("empList",empList);
		
		return "content/proj3Changepw.tiles";
		
	}
	

}
