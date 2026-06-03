package kr.or.smartfarm.report;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReportController {

	@Autowired
	ReportService reportService;
	
	@GetMapping("/report")
	public String report(Model model) {
	    try {
	    	
	        List<ReportSummaryDTO> result = reportService.selectAll();
	        System.out.println("조회된 데이터 개수: " + result.size());
	        model.addAttribute("result", result);
	        
	        List<ReportSummaryDTO> resultqc = reportService.selectQc();
	        model.addAttribute("resultqc", resultqc);
	        
	        List<ReportSummaryDTO> resultIO = reportService.selectIO(); 
	        model.addAttribute("resultIO", resultIO);
	        
	        List<ReportSummaryDTO> resultProc = reportService.selectProc();
	        model.addAttribute("resultProc", resultProc);
	        // 불량품
	        List<ReportSummaryDTO> resultDefective = reportService.selectDefective();
	        model.addAttribute("resultDefective", resultDefective);
	        // 설비
	        List<ReportSummaryDTO> resultEquip = reportService.selectEquip();
	        model.addAttribute("resultEquip", resultEquip);
	        
	    } catch (Exception e) {
	        System.out.println("에러 발생 지점: " + e.getMessage());
	        e.printStackTrace(); 
	    }
	    return "content/report.tiles";
	}
	
	
}
