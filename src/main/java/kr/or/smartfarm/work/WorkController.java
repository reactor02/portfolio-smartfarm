package kr.or.smartfarm.work;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/work")
public class WorkController {
	
	@RequestMapping("/detail")
	public String detail() {
		
		return"content/workDetail.tiles";
	}
}
