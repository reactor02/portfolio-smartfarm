package kr.or.smartfarm.stock;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class StockController {
	
	@RequestMapping("stockSelect")
	public String goStock() {
		
		return "stockSelect";
	}
}
