package kr.or.smartfarm.dashboard;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class DashController {
	
	@Autowired
	DashService dashService;

	@GetMapping("/dashboard")
	public String dashboard(
			@RequestParam(required = false) String period, 
			@RequestParam(required = false) String startDate, 
			@RequestParam(required = false) String endDate, 
			Model model) {
		try {
			
		
			if(startDate != null && !startDate.isEmpty() && 
					endDate != null && !endDate.isEmpty()) {
				period = null; 
			} else {
				if(period == null) period = "day";
				
			}
			
			
			// 생산계획, 작업지시 대시보드 위젯
			Map resultDash = dashService.resultDashBoard();
			model.addAttribute("resultDash", resultDash);
			
			// 공지
			List<DashDTO> resultB = dashService.selectBoard(); 
			model.addAttribute("resultB", resultB);
			
			// 차트 
			List<DashDTO> resultPS = dashService.selectPS();
			ObjectMapper mapper = new ObjectMapper(); 
			String json = mapper.writeValueAsString(resultPS);
			model.addAttribute("chartData",json);
			
			// KPI(기간 적용) 
			List<DashDTO> resultKPIPP = dashService.selectKPIPP(period, startDate, endDate);
			model.addAttribute("resultKPIPP", resultKPIPP);
			List<DashDTO> resultKPIShip = dashService.selectKPIShip(period, startDate, endDate);
			model.addAttribute("resultKPIShip", resultKPIShip);
			List<DashDTO> resultKPIDefect = dashService.selectKPIDefect(period, startDate, endDate);
			model.addAttribute("resultKPIDefect", resultKPIDefect);
			Integer resultKPIFacility = dashService.selectKPIFacility();
			model.addAttribute("resultKPIFacility", resultKPIFacility);
			//
			model.addAttribute("period", period);
			model.addAttribute("startDate", startDate);
			model.addAttribute("endDate", endDate);
			
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
