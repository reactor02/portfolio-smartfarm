package kr.or.smartfarm.vender;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
		
		return "content/vender";
	}
	
	@RequestMapping(value="/list", method= RequestMethod.GET)
	@ResponseBody
	public List<VenderDTO> list(@RequestParam(value="page", defaultValue="1") int page){
		System.out.println("/list 실행");
		
		List<VenderDTO> list = venderService.getVenderList(page); 
		System.out.println("VenderController: List:" + list);
		
		return list;
	}
	
}
