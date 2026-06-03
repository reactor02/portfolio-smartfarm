package kr.or.smartfarm.facility;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.prod.ProdDTO;
import kr.or.smartfarm.qc.QcDTO;

@Controller
public class FacilityController {
//	log4
	private static final Logger logger = LoggerFactory.getLogger(FacilityController.class);
	int debugLevel = 0;
	
//	find service
	@Autowired
	FacilityService facilityService;

//	list
	@RequestMapping("/facility")
	public String facility(Model model) {
		
		Map result = facilityService.selectAll();
		model.addAttribute("result", result);
		
		List emp = facilityService.selectEmp();
		model.addAttribute("emp", emp);
 
		return "content/facilitySelect.tiles";
	}
	
	@ResponseBody
	@RequestMapping(value = "/ajaxList", method = RequestMethod.GET)
	public Map<String, Object> ajaxList() {
		Map<String, Object> result = new HashMap();
		facilityService.updateRandom();
		result.put("list", facilityService.ajaxList());
	    // 이 메서드는 JSP를 반환하지 않고 Map 자체를 JSON 문자열로 변환해 응답합니다.
	    return result; 
	}
	
	//////////////////////////////
	//// facility Log
	//////////////////////////////
	
//	list2
	@RequestMapping("/facilityLog")
	public String facilityLog(
			@RequestParam(value = "page", defaultValue = "1") int page,
			Model model) {
		
		Map fname = facilityService.selectAll();
		model.addAttribute("fname", fname);
		
		List result = facilityService.selectLogAll(page);
		model.addAttribute("result", result);
		
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		model.addAttribute("pageInfo", pageInfo);
		
		return "content/facilityLog.tiles";
	}
	
	//search
		@RequestMapping("/searchFM")
		@ResponseBody
		public Map searchQc(
		        @RequestParam(value = "page", defaultValue = "1") int page,
		        @RequestParam(value = "sDate") String sDate,
		        @RequestParam(value = "eDate") String eDate,
		        @RequestParam(value = "type") String type
		        ) {

		    Map result = new HashMap();
		    
		    try {
		        Map searchMap = new HashMap();
		        searchMap.put("page", page);
		        searchMap.put("sDate", sDate);
		        searchMap.put("eDate", eDate);
		        searchMap.put("type", type);
		        System.out.println("searchMap 조회 : " + searchMap);
		        
		        List searchResult = facilityService.searchFM(searchMap);
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
		
		@RequestMapping("/insertFM")
		//상세페이지 들어가는 로직
		public String insertFM(FacilityDTO facilityDTO, Model model) {
			
			facilityService.insertFM(facilityDTO);
			
			return "redirect:/facilityLog";
		}
}
