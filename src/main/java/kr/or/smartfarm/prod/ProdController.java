package kr.or.smartfarm.prod;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class ProdController {
	
	@Autowired
	ProdService prodService;
	
	@RequestMapping("/list")
	public String list (@RequestBody ProdSearchDTO searchDTO) {
		System.out.println("골골");
		//전체 내용이 오는 곳으로 만든다
		
		
		return "prod.tiles";
	}
	
}
