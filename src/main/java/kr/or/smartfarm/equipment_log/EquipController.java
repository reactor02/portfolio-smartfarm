package kr.or.smartfarm.equipment_log;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.prod.ProdDTO;

@Controller
public class EquipController {
//	log4
	private static final Logger logger = LoggerFactory.getLogger(EquipController.class);
	int debugLevel = 0;
	
//	find service
	@Autowired
	EquipService equipService;

//	list
	@RequestMapping("/equip")
	public String equip(
			@RequestParam(value = "page", defaultValue = "1") int page, 
			Model model) {
		
		List result = equipService.selectAll(page);
		model.addAttribute("result", result);
		
		List item = equipService.selectItemEquip();
		model.addAttribute("item", item);
		
		List emp = equipService.selectEmp();
		model.addAttribute("emp", emp);
		
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		model.addAttribute("pageInfo", pageInfo);
		
		
		return "content/equipSelect.tiles";
	}
	
//search
	@RequestMapping("/searchEquip")
	@ResponseBody
	public Map searchEquip(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "type") String type,
	        @RequestParam(value = "keyword") String keyword
	        ) {

	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("type", type);
	        searchMap.put("keyword", keyword );
	        System.out.println(searchMap);
	        
	        List searchResult = equipService.searchEquip(searchMap);
	        result.put("searchResult", searchResult);

	        result.put("status", "good");
	        if(searchResult != null) {
	        	
	        	PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
	        	System.out.println("pageInfo === " + pageInfo);
	        	result.put("pageInfo", pageInfo);
	        }else {
	        	System.out.println("else 탔음!!!");
	        	PageInfo pageInfo = new PageInfo();
	        	result.put("pageInfo", pageInfo);
	        }
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        result.put("status", "error");
	    }
	    
	    return result;
	}
	
// insert 
    @RequestMapping(value = "/insertEquip", method = RequestMethod.POST)
    public String create(EquipDTO equipDTO, Model model) {
        equipService.insertEquip(equipDTO);
        return "redirect:content/equipSelect.tiles";
    }
}
