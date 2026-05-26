package kr.or.smartfarm.bom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

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
		return "content/bomSelect.tiles";
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
	
	@GetMapping("/modalSearch1")
	@ResponseBody
	public Map modalSearch1(@RequestParam(value="keyword", required=false)String keyword) {
		Map result = null;
		 result = bomService.modalSearch(keyword);
		return result;
}
	
	@RequestMapping("/modalChildSearch")
	@ResponseBody
	public Map childSearch(@RequestParam(value="item_num", required=false)String itemNum) {
		Map result = null;
		result = bomService.childSearch(itemNum);
		return result;
	}
	
	//등록 눌렀을 때 insert
	@RequestMapping("/insertBOM")
	@ResponseBody
	public Map insertBom(@RequestBody BomDTO bomDto) {
		Map result = new HashMap();
		

		try {
	        // 서비스 호출
	        bomService.insertBom(bomDto);
	        
	        result.put("status", "success");
	        result.put("message", "BOM 등록 완료");
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("status", "fail");
	        result.put("message", "등록 실패: " + e.getMessage());
	    }
		return result;
	}
	
	// 디테일 페이지로 이동
	@RequestMapping("/bomDetail")
	public String Detail(@RequestParam(value="bom_num", required=false)String bomNum, Model model) {
		List result = null;
		result = bomService.selectDetail(bomNum);
		System.out.println("조회된 결과 리스트: " + result);
		model.addAttribute("resultList", result);
		return "content/bomDetail.tiles";
	}
	
	//머신러닝 사용
	@PostMapping("/predict-loss")
	@ResponseBody
	public Map<String, Object> predictLoss(@RequestBody BomDTO bomDTO) {
		// 1. 파이썬 Flask 서버 주소
        String pythonUrl = "http://127.0.0.1:5000/predict";

        // 2. 스프링 HTTP 통신 객체 생성
        RestTemplate restTemplate = new RestTemplate();

        try {
            // 3. bomDTO를 파이썬 서버로 통째로 전송 (파이썬은 필요한 변수명만 골라서 씀)
            // 파이썬 서버가 리턴하는 {'predicted_loss': 2.85}를 Map 형태로 받아옵니다.
            Map<String, Object> response = restTemplate.postForObject(pythonUrl, bomDTO, Map.class);
            
            return response; 
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorMap = new HashMap();
            errorMap.put("error", "AI 예측 서버가 응답하지 않습니다. 파이썬 서버(server.py)가 켜져있는지 확인하세요.");
            return errorMap;
        }
	}
	
	//모달 수정창 상태 변경 로직
	@RequestMapping("/updateStatus")
	public String updateStatus(BomDTO bomDTO) {
		bomService.update(bomDTO);
		return "redirect:/bomDetail?bom_num=" + bomDTO.getBom_num();
	}
	
}//클래스 닫음
