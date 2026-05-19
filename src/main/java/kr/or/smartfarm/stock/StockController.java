package kr.or.smartfarm.stock;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class StockController {
	
	@Autowired
	StockService stockService;
	
	@RequestMapping("/stockSelect")
	public String goStock(Model model) {
		List result = null;
		System.out.println("123123");
		 result = stockService.selectAll();
		 model.addAttribute("result" , result);
		return "content/stockSelect";
	}
}
