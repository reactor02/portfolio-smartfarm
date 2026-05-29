package kr.or.smartfarm.qc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.equipment_log.EquipService;


@Controller
public class QcController {
	
//	log4
	private static final Logger logger = LoggerFactory.getLogger(QcController.class);
	int debugLevel = 0;
	
//	find service
	@Autowired
	QcService qcService;
	
	@Autowired
	EquipService equipService;

//	list
	@RequestMapping("/qc")
	public String qc(
			@RequestParam(value = "page", defaultValue = "1") int page, 
			Model model) {
		
		List result = qcService.selectAll(page);
		model.addAttribute("result", result);
		
		List waiting = qcService.selectWaiting();
		model.addAttribute("waiting", waiting);
		
		List item = qcService.selectItem();
		model.addAttribute("item", item);
		
		List qc = qcService.selectAllQc();
		model.addAttribute("qc", qc);
		
		List emp = equipService.selectEmp();
		model.addAttribute("emp", emp);
		
		
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		model.addAttribute("pageInfo", pageInfo);
		
		
		return "content/qcSelect.tiles";
	}

	
//search
	@RequestMapping("/searchQc")
	@ResponseBody
	public Map searchQc(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "sDate") String sDate,
	        @RequestParam(value = "eDate") String eDate,
	        @RequestParam(value = "type") String type,
	        @RequestParam(value = "keyword") String keyword
	        ) {

	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("sDate", sDate);
	        searchMap.put("eDate", eDate);
	        searchMap.put("type", type);
	        searchMap.put("keyword", keyword );
	        System.out.println("searchMap 조회 : " + searchMap);
	        
	        List searchResult = qcService.searchQc(searchMap);
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
	
	@RequestMapping("/qcDetail")
	//상세페이지 들어가는 로직
	public String Detail(@RequestParam(value="io_num", required=false)Integer io_num, Model model) {
		
		System.out.println("io_num : " + io_num );
		QcDTO result = qcService.selectDetail(io_num);
		model.addAttribute("result", result);
		List list = qcService.selectLog(io_num);
		model.addAttribute("list", list);
		return "content/qcDetail.tiles";
	}
	
	@RequestMapping("/insertQc")
	//상세페이지 들어가는 로직
	public String insertQc(QcDTO qcDTO, Model model) {
		
		// qc 출고
		// io_num > 시퀀스
		// io_type > '출고'
		// io_qty = dto
		// io_date > sysdate
		// qc_num > dto
		// lot_num > dto
		// io_reason > 품질검사
		// facility_num > 7
		// emp_num > dto
		// qc_chked > 'N'
		
		// 총량 확인
		QcDTO crrnt_qty = qcService.crrnt_qty(qcDTO);
		
		if(		   qcDTO.getIo_qty() < 0 
				|| crrnt_qty.getIo_qty() < qcDTO.getIo_qty()) {
			
			System.out.println("잘못된 값입니다."); // 방어 코딩
			
		} else if (crrnt_qty.getIo_qty() == qcDTO.getIo_qty()) {
			// 불량 X qc 등록
			
			// io 출고 등록
			qcService.insertQc1(qcDTO);
			// io 입고 등록
			qcService.insertQc2(qcDTO);
		} else if (crrnt_qty.getIo_qty() > qcDTO.getIo_qty()) {
			// 불량 O qc 등록
			int defect_qty = crrnt_qty.getIo_qty() - qcDTO.getIo_qty();
			qcDTO.setDefect_qty(defect_qty);
			qcService.insertDefect(qcDTO);
			
			// io 출고 등록
			qcService.insertQc1(qcDTO);
			// io 입고 등록
			qcService.insertQc2(qcDTO);
		}
		
		
		
//		QcDTO qcChk = qcService.qcChk(qc_num);
//		String pass = qcChk.getQc_pass();
		

		// io 입고 등록
//		if(!("".equals(pass)) && pass != null ) {
//			if("PASS".equals(pass)) {
//				// 품질 insert
//				qcDTO.setQc_pass("PASS");
//			}
//			if("FAILED".equals(pass)) {
//				// 불량 insert
//				qcDTO.setQc_pass("FAILED");
//			}
//			if("WAITING".equals(pass)) {
//				// 불량 insert
//				qcDTO.setQc_pass("WAITING");
//			}
//		} else {
//			System.out.println("잘못된 값");
//		}
		// io 입고 등록
//		qcService.insertQc2(qcDTO);
		
		
		return "redirect:qc";
	}

}
