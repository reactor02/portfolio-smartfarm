package proj03.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UserController {
	
	@Autowired
	UserService userServiceImpl;
	
	@RequestMapping("/User")
	public ModelAndView user() {
		
		ModelAndView mav = new ModelAndView("user");
		
		return mav;
	}

}
