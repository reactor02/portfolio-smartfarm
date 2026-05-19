package kr.or.smartfarm.Io;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IoController {
	@RequestMapping("/test")
	public String test() {
		
		return "sideBar";
	}
}
