package kr.or.smartfarm.stock;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.github.pagehelper.PageInfo;



@Controller
public class StockController {
	
	@Autowired
	StockService stockService;
	
	@RequestMapping("/stockSelect")
	public String goStock(@RequestParam(value = "page", defaultValue = "1")int page,Model model) {
		List result = null;
		 result = stockService.selectAll(page);
		 model.addAttribute("result" , result);
		 
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/stockSelect";
	}
}
