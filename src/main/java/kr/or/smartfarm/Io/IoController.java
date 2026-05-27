package kr.or.smartfarm.Io;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IoController {
	
	@RequestMapping("/io")
	public String ioSelect() {
		System.out.println("/io들어옴");
		return "content/ioSelect.tiles";
	}
}
