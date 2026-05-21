package kr.or.smartfarm.stock;

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
public class StockController {
	
	@Autowired
	StockService stockService;
	
	@RequestMapping("/stockSelect")
	public String goStock(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 result = stockService.selectAll(page);
		 model.addAttribute("result" , result);
		 model.addAttribute("msg", msg);
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/stockSelect";
	}
	
	@RequestMapping("/searchStock")
	@ResponseBody
	public Map searchStocks(
	        @RequestParam(value = "page", defaultValue = "1") int page,
//	        @RequestParam(value = "type", required = false, defaultValue = "all") String type,
//	        @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword
	        @RequestParam(value = "type") String type,
	        @RequestParam(value = "keyword") String keyword
	        ) {

	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("type", type);
	        searchMap.put("keyword", keyword );
System.out.println(searchMap);
	        
	        List searchResult = stockService.searchStock(searchMap);
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
	
	//모달에서 검색
	@RequestMapping("/modal")
	@ResponseBody
	public Map modal(@RequestParam(value = "search")String keyword) {
		Map result = null;
		System.out.println(keyword);
		result = stockService.modalSearch(keyword);
		return result;
	}
	//모달 등록
	@RequestMapping("/insertController")
	public String insertController(StockDTO dto, Model model) {
		System.out.println("insertController들어옴");
		int result = stockService.insertStock(dto);
		model.addAttribute("inertResult", result);
		if(result > 0) {
			return "redirect:/stockSelect?msg=true";
		}else {
			return "redirect:/stockSelect?msg=false";
		}
		
	}
}

