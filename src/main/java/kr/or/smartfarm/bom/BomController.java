package kr.or.smartfarm.bom;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class BomController {
	
	@RequestMapping("/selectBom")
	public String bomSelect() {
		
		return "content/bomSelect";
	}
}
