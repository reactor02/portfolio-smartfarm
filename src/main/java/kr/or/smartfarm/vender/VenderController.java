package kr.or.smartfarm.vender;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

@Controller
@RequestMapping("/vender")
public class VenderController {

	private static final Logger logger = LoggerFactory.getLogger(VenderController.class);
	
	@Autowired 
	VenderService venderService;
	
	@RequestMapping("")
	public String vender(@RequestParam(value = "page", defaultValue = "1") int page,Model model) {
		
		List result = null;

		result = venderService.getVenderList(page);
		 
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		model.addAttribute("pageInfo", pageInfo);
				
		return "content/vender.tiles";
	}
	
	@RequestMapping(value="/list", method= RequestMethod.GET)
	@ResponseBody
	public List<VenderDTO> list(@RequestParam(value="page", defaultValue="1") int page){
		System.out.println("/list 실행");
		
		List<VenderDTO> list = venderService.getVenderList(page); 
		System.out.println("VenderController: List:" + list);
		
		return list;
	}
	
	@GetMapping("/one")
	public String One(int vender_num, Model model) {
		System.out.println("/one 실행");
		
		VenderDTO venderDTO = venderService.getVender(vender_num);
		model.addAttribute("venderDTO", venderDTO);
		System.out.println("/one: vender_num: " + vender_num);
		
		return "content/venderdetail.tiles";
	}
	
	
	@PostMapping("/insert")
	public String insert(VenderDTO venderDTO) {
		System.out.println("post /insert 실행");
		 
		 System.out.println(venderDTO.getVender_type());
		
		
		venderService.insertVender(venderDTO);
		return "redirect:/vender";
	}
	
	@GetMapping("/update")
	public String update(@RequestParam("vender_num") int vender_num, Model model) {
		System.out.println("get /update 실행");
		
		VenderDTO venderDTO = venderService.findById(vender_num);
		
		model.addAttribute("venderDTO", venderDTO);
		model.addAttribute("mode", "update");
		
		return "content/vender";
	}
	
	@PostMapping("/update")
	public String update(VenderDTO venderDTO, Model model) {
		System.out.println("post /update 실행");
		logger.info("venderDTO : " + venderDTO);
		
		int result = venderService.updateVender(venderDTO);
		return "redirect:/vender";
	}
	
	@RequestMapping("/delete")
	public String deleteVender(VenderDTO venderDTO, Model model) {
		System.out.println("/delete 실행");
		logger.info("venderDTO : " + venderDTO);
		
		int result = venderService.deleteVender(venderDTO);
		
		return "redirect:/vender";
	}
	
	
	@RequestMapping("/search")
	@ResponseBody
	public Map search(
			@RequestParam(value = "page", defaultValue="1") int page, 
			@RequestParam(value = "type") String type,
			@RequestParam(value = "keyword") String keyword
			) {
		Map result = new HashMap();
		
		try {
			Map searchMap = new HashMap();
			searchMap.put("page",  page);
			searchMap.put("type",type);
			searchMap.put("keyword",keyword);
			System.out.println(searchMap);
			
			List searchResult = venderService.search(searchMap);
			result.put("searchResult", searchResult);
			
			result.put("status",  "good");
			if(searchResult != null) {
				PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
				result.put("pageInfo", pageInfo);
			} else {
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
