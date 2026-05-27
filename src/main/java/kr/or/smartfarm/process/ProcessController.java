package kr.or.smartfarm.process;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.github.pagehelper.PageInfo;


@Controller
public class ProcessController {

	@Autowired
	ProcessService Service;
	//처음 들어오는 페이지 (목록)
	@RequestMapping("/process")
	public String bomSelect(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 result = Service.selectAll(page);
		 model.addAttribute("result" , result);
		 
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/processSelect.tiles";
	}
	
	
	// 디테일 페이지로 이동
	@RequestMapping("/processDetail")
	public String Detail(@RequestParam(value="item_num", required=false)int itemNum, Model model) {
		List result = null;
		result = Service.selectDetail(itemNum);
		System.out.println("조회된 결과 리스트: " + result);
		model.addAttribute("resultList", result);
		return "content/processDetail.tiles";
	}
}
