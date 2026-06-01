package kr.or.smartfarm.dashboard;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashController {
	
	@Autowired
	DashService dashService;

	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		try {
			
			List<DashDTO> resultB = dashService.selectBoard(); 
			model.addAttribute("resultB", resultB);
			
		} catch (Exception e ) {
			System.out.println("에러 발생 지점: " + e.getMessage());
			e.printStackTrace();
		}
		
		return "content/dash.tiles";
	}
	
	@GetMapping("/dashboard2")
	public String dashboard2(Model model) {
		try {
			
			List<DashDTO> resultB = dashService.selectBoard(); 
			model.addAttribute("resultB", resultB);
			
		} catch (Exception e ) {
			System.out.println("에러 발생 지점: " + e.getMessage());
			e.printStackTrace();
		}
		
		return "content/dash2";
	}
}
