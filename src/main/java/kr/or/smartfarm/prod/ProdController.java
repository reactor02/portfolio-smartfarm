package kr.or.smartfarm.prod;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/prod")
public class ProdController {
	
	@Autowired
	ProdServiceImpl prodService;
	
	@RequestMapping("/list")
	public String list(@ModelAttribute ProdPageDTO pageDTO, Model model) {
	   System.out.println("prod/list 접속");
		
		List<ProdDTO> list = prodService.getList(pageDTO);
	    List<SelectOptionDTO> facilityList = prodService.getFacilityOptions();
	    List<SelectOptionDTO> itemList     = prodService.getItemOptions();

	    model.addAttribute("list",         list);
	    model.addAttribute("page",         pageDTO);
	    model.addAttribute("facilityList", facilityList);
	    model.addAttribute("itemList",     itemList);

	    return "content/prod.tiles";
	}
	
}
