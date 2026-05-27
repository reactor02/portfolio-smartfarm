package kr.or.smartfarm.request;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

@Controller
public class RequestController {
	
	@Autowired
	RequestService RequestService;
	
	@RequestMapping("/request")
	public String bomSelect(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 result = RequestService.selectAll(page);
		 model.addAttribute("result" , result);

		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);

		 // 등록 모달용 완제품 목록
		 model.addAttribute("itemList", RequestService.loadProducts());

		return "content/request.tiles";
	}
	
	
	
	//검색 버튼으로 검색했을 때
	@RequestMapping("/searchRequest")
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
	        
	        List searchResult = RequestService.searchRequest(searchMap);
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


	/* ── 거래처 검색 (등록 모달 AJAX용) ── */
	@RequestMapping("/searchVender")
	@ResponseBody
	public List searchVender(@RequestParam(value = "keyword", defaultValue = "") String keyword) {
		return RequestService.searchVender(keyword);
	}

	/* ── 품목 목록 (등록 모달 AJAX용) ── */
	@RequestMapping("/loadItems")
	@ResponseBody
	public List loadItems() {
		return RequestService.loadItems();
	}

	/* ── 주문 등록 ── */
	@PostMapping("/insertRequest")
	public String insertRequest(
	        @RequestParam("vender_seq")   int    venderSeq,
	        @RequestParam("item_num")     int    itemNum,
	        @RequestParam("request_date") String requestDate,
	        @RequestParam("due_date")     String dueDate) {

		Map insertMap = new HashMap();
		insertMap.put("vender_num",   venderSeq);
		insertMap.put("item_num",     itemNum);
		insertMap.put("request_date", requestDate);
		insertMap.put("due_date",     dueDate);

		RequestService.insertRequest(insertMap);
		return "redirect:/request";
	}


}
