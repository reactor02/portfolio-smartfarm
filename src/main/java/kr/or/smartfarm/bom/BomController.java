package kr.or.smartfarm.bom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

@Controller
public class BomController {
	
	@Autowired
	BomService bomService;
	
	@RequestMapping("/selectBom")
	public String bomSelect(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 result = bomService.selectAll(page);
		 model.addAttribute("result" , result);
		 
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/bomSelect";
	}
	
	
	
	//검색 버튼으로 검색했을 때
	@RequestMapping("/searchBOM") 
	@ResponseBody
	public Map searchStocks(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "type") String type,
	        @RequestParam(value = "keyword") String keyword,
	        @RequestParam(value = "status") String status,
	        @RequestParam(value = "sDate") String sDate,
	        @RequestParam(value = "eDate") String eDate
	           
	        ) {
		
		System.out.println("status"+status);
		System.out.println("type"+type);
	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("type", type);
	        searchMap.put("keyword", keyword );
	        searchMap.put("status", status);
	        searchMap.put("sDate", sDate);
	        searchMap.put("eDate", eDate );
System.out.println(searchMap);
	        
	        List searchResult = bomService.searchBom(searchMap);
	        result.put("searchResult", searchResult);

	        result.put("status", "good");
	        if(searchResult != null) {
	        	PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
	        	result.put("pageInfo", pageInfo);
	        }else {
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
