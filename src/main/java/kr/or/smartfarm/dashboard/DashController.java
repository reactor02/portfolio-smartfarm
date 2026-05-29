package kr.or.smartfarm.dashboard;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashController {

	@GetMapping("/dashboard")
	public String dashboard() {
		return "content/dash";
	}
}
