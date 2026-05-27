package kr.or.smartfarm.qc;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.github.pagehelper.PageInfo;


@Controller
public class QcController {
	
//	log4
	private static final Logger logger = LoggerFactory.getLogger(QcController.class);
	int debugLevel = 0;
	
//	find service
	@Autowired
	QcService qcService;

//	list
	@RequestMapping("/qc")
	public String qc(
			@RequestParam(value = "page", defaultValue = "1") int page, 
			Model model) {
		
		List result = qcService.selectAll(page);
		model.addAttribute("result", result);
		
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		model.addAttribute("pageInfo", pageInfo);
		
		
		return "content/qcSelect";
	}


}
