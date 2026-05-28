package kr.or.smartfarm.process;

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
public class ProcessController {

	@Autowired
	ProcessService Service;
	//처음 들어오는 페이지 (목록)
	@RequestMapping("/process")
	public String bomSelect(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 result = Service.selectAll(page);
		 model.addAttribute("result" , result);
		 
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/processSelect.tiles";
	}
	
	
	// 디테일 페이지로 이동
	@RequestMapping("/processDetail")
	public String Detail(@RequestParam(value="item_num", required=false)int itemNum, Model model) {
		List result = null;
		result = Service.selectDetail(itemNum);
		System.out.println("조회된 결과 리스트: " + result);
		model.addAttribute("resultList", result);
		return "content/processDetail.tiles";
	}
	
	//검색 버튼 눌러서 검색
	//검색 버튼으로 검색했을 때
		@RequestMapping("/searchProcess") 
		@ResponseBody
		public Map searchStocks(
		        @RequestParam(value = "page", defaultValue = "1") int page,
		        @RequestParam(value = "type") String type,
		        @RequestParam(value = "keyword") String keyword,
		        @RequestParam(value = "process_status") String process_status
		        ) {
			System.out.println("process_status===" + process_status);
		    Map result = new HashMap();
		    
		    try {
		        Map searchMap = new HashMap();
		        searchMap.put("page", page);
		        searchMap.put("type", type);
		        searchMap.put("keyword", keyword );
		        searchMap.put("process_status", process_status);
	System.out.println(searchMap);
		        
		        List searchResult = Service.searchProcess(searchMap);
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
		@RequestMapping("/processModal")
		@ResponseBody
		public Map modal(@RequestParam(value = "search")String keyword) {
			Map result = null;
			System.out.println(keyword);
			result = Service.modalSearch(keyword);
			return result;
		}
}
