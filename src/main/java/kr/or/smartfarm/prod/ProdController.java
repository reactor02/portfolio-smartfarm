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
	public String list (@ModelAttribute ProdPageDTO pageDTO, Model model) {
		System.out.println("prodlist 접속");
		List<ProdDTO> list = prodService.getList(pageDTO);
		System.out.println("list 컨트롤러 도착" + list);
		model.addAttribute("list", list);
		model.addAttribute("page", pageDTO);
		
		
		
		return "content/prod.tiles";
	}
	
}
