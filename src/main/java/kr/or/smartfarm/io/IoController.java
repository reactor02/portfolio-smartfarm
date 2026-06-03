package kr.or.smartfarm.io;

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
public class IoController {
	
	@Autowired
	IoService ioService;
	
	//목록 페이지로 이동(초기 진입)
	@RequestMapping("/io")
	public String ioSelect(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		result = ioService.selectAll(page);
        List facilityList = ioService.facility();
        model.addAttribute("facilityList", facilityList);
		model.addAttribute("result" , result);
		
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/ioSelect.tiles";
	}
	
	
	//검색
	//검색 버튼으로 검색했을 때
		@RequestMapping("/searchIo") 
		@ResponseBody
		public Map searchStocks(
		        @RequestParam(value = "page", defaultValue = "1") int page,
		        @RequestParam(value = "type") String type,
		        @RequestParam(value = "keyword") String keyword,
		        @RequestParam(value = "sDate") String sDate,
		        @RequestParam(value = "eDate") String eDate,
		        @RequestParam(value = "io_type") String io_type
		        ) {
			
		    Map result = new HashMap();
		    
		    try {
		        Map searchMap = new HashMap();
		        searchMap.put("page", page);
		        searchMap.put("type", type);
		        searchMap.put("keyword", keyword );
		        searchMap.put("sDate", sDate);
		        searchMap.put("eDate", eDate );
		        searchMap.put("io_type", io_type );
		        System.out.println("searchMap===" + searchMap);
	System.out.println(searchMap);

		        List searchResult = ioService.searchIo(searchMap);
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
		
		//모달에서 자재명 검색 했을 때
		@RequestMapping("/modalSearch2")
		@ResponseBody
		public List searchModal(@RequestParam(value = "keyword") String keyword) {
			List result = null;
			result = ioService.modalSearch(keyword);
			return result;
		}
		
		@RequestMapping("insertIo")
		public String insertIo(IoDTO ioDTO) {
			System.out.println("컨트롤러에서 받은 값:  ===" + ioDTO.getIo_reason());
			ioService.insertData(ioDTO);
			
			return "redirect:io";
		}
		
		@RequestMapping("/outModalSelect")
		@ResponseBody
		public List outModalSelect(IoDTO ioDTO) {
			List result = null;
			result = ioService.outModal();
			return result;
		}
		
		
		@RequestMapping("/insertOutbound")
		public String insertOut(IoDTO ioDTO) {
			
			int result = ioService.outModalInsert(ioDTO);
			return "redirect:/io";
		}
}
