package kr.or.smartfarm.vender;

import java.util.List;
import java.util.Map;

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
	
	@GetMapping("/one")
	public String One(int vender_num, Model model) {
		System.out.println("/one 실행");
		
		VenderDTO venderDTO = venderService.getVender(vender_num);
		model.addAttribute("venderDTO", venderDTO);
		System.out.println("/one: vender_num: " + vender_num);
		
		return "content/venderdetail";
	}
	
	@GetMapping("/insert")
	public String insert() {
		System.out.println("get /insert 실행");
		
		return "content/vender";
	}
	
	@PostMapping("/insert")
	public String insert(VenderDTO venderDTO) {
		System.out.println("post /insert 실행");
		
		venderService.insertVender(venderDTO);
		return "redirect:/vender";
	}
	
	@GetMapping("/update")
	public String update(@RequestParam("vender_num") int vender_num, Model model) {
		System.out.println("/update 실행");
		
		VenderDTO vender = venderService.findById(vender_num);
		
		model.addAttribute("vender", vender);
		model.addAttribute("mode", "update");
		
		return "content/vender";
	}
	
	@PostMapping("/update")
	public String update(VenderDTO venderDTO, Model model) {
		System.out.println("/update 실행");
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
	
	
}
