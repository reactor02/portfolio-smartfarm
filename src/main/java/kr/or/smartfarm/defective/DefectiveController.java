package kr.or.smartfarm.defective;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

@Controller
public class DefectiveController {
//	log4
	private static final Logger logger = LoggerFactory.getLogger(DefectiveController.class);
	int debugLevel = 0;
	
//	find service
	@Autowired
	DefectiveService defectiveService;

//	list
	@RequestMapping("/defective")
	public String defective(
			@RequestParam(value = "page", defaultValue = "1") int page, 
			Model model) {
		
		List result = defectiveService.selectAll(page);
		model.addAttribute("result", result);
		
		List qcType = defectiveService.selectQcType();
		model.addAttribute("qcType", qcType);
		
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		model.addAttribute("pageInfo", pageInfo);
		
		
		return "content/defectiveSelect.tiles";
	}
	
//search
	@RequestMapping("/searchDefect")
	@ResponseBody
	public Map searchDefect(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "sDate") String sDate,
	        @RequestParam(value = "eDate") String eDate,
	        @RequestParam(value = "type") String type,
	        @RequestParam(value = "keyword") String keyword
	        ) {

	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("sDate", sDate);
	        searchMap.put("eDate", eDate);
	        searchMap.put("type", type);
	        searchMap.put("keyword", keyword );
	        System.out.println("searchMap 조회 : " + searchMap);
	        
	        List searchResult = defectiveService.searchDefect(searchMap);
	        result.put("searchResult", searchResult);

	        result.put("status", "good");
	        if(searchResult != null) {
	        	
	        	PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
	        	System.out.println("pageInfo === " + pageInfo);
	        	result.put("pageInfo", pageInfo);
	        }else {
	        	System.out.println("else 탔음!!!");
	        	PageInfo pageInfo = new PageInfo();
	        	result.put("pageInfo", pageInfo);
	        }
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        result.put("status", "error");
	    }
	    
	    return result;
	}
		
}
