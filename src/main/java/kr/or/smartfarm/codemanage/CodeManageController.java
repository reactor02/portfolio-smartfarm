package kr.or.smartfarm.codemanage;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.usermanage.UserManageDTO;

@Controller
public class CodeManageController {
	
	
	@Autowired
	CodeManageService codeManageService;
	
	
	
	@GetMapping("/codemanage")
	public String CodemanageGet(
			  // 💡 다른 팀원들이 쓰는 규칙에 맞춰 파라미터명을 'page'로 매핑합니다.
	        @RequestParam(value = "page", required = false, defaultValue = "1") int page, 
	        Model model) { // 💡 데이터를 담을 가방(Model) 주입
	    System.out.println("codemanageGet 실행");
	    

	    // 1. 5개씩 끊어오도록 PageHelper 세팅 (pageNum 대신 page 변수 사용)
	    PageHelper.startPage(page, 5);
	    

	    // 1. 서비스에서 전체 회원 목록(List) 조회
	    List<CodeManageDTO> CodeList = codeManageService.getCodeManage(page);
	    
	 // 3. 조회된 userList를 PageInfo 객체로 포장
	    PageInfo<CodeManageDTO> pageInfo = new PageInfo(CodeList);
	    
	    // 1-2. 서비스에서 type명 조회
	    List<CodeManageDTO> selectd = codeManageService.selectd();
	    
	    // 1-3. 서비스에서 unit 목록 조회
	    List<CodeManageDTO> selectl = codeManageService.selectl();
	    
	    // 1-3. 서비스에서 담당자 조회
	    List<CodeManageDTO> selectm = codeManageService.selectm();
	    
	    // 5. ⭐ 핵심: 다른 팀원들이 쓰는 paging.jsp 내부 변수명인 "pageInfo"로 가방에 넣습니다.
	    model.addAttribute("pageInfo", pageInfo); 
	    
	 // 6. 기존 JSP 화면에서 사용할 데이터들 바인딩
	    model.addAttribute("CodeList", pageInfo.getList()); // 딱 5개만 담긴 리스트
	    model.addAttribute("selectd", selectd);
	    model.addAttribute("selectl", selectl);
	    model.addAttribute("selectm", selectm);
	    
	    // 3. 타일즈 뷰 리턴 (화면이 그려지면서 데이터가 함께 배달됩니다)
	    return "content/codemanage.tiles";
	}
	
	
	@PostMapping("/codeinsert")
	public String Codeinsert(
			CodeManageDTO CodeManageDTO, 
			RedirectAttributes rttr) { 
	    System.out.println("codeinsertPost 실행");
	    
	    // 1. 서비스 실행 (정상 등록 시 1, 실패 시 0 또는 예외 반환)
	    int resultCount = codeManageService.CodeInsert(CodeManageDTO);
	    
	    // 2. 성패 로직 처리 및 결과 메시지 생성
	    String msgType;
	    String msgContent;
	    
	    if (resultCount > 0) {
	        msgType = "success";
	        msgContent = "사원이 정상적으로 등록되었습니다.";
	    } else {
	        msgType = "error";
	        msgContent = "등록에 실패했습니다. 입력 데이터를 확인해주세요.";
	    }
	    
	    // 3. 리다이렉트 화면까지 안전하게 메시지 배달 (Flash Attribute)
	    rttr.addFlashAttribute("msg", msgContent);
	    
	    // 4. 타일즈 막힘 해결을 위해 GET 메서드로 리다이렉트
	    return "redirect:/codemanage";
	}
	
	@PostMapping("/codeupdate")
	public String Codeupdate(
			CodeManageDTO CodeManageDTO, 
			RedirectAttributes rttr) { 
		System.out.println("codeupdatePost 실행");
		
		// 1. 서비스 실행 (정상 등록 시 1, 실패 시 0 또는 예외 반환)
		int resultCount = codeManageService.CodeUpdate(CodeManageDTO);
		
		// 2. 성패 로직 처리 및 결과 메시지 생성
		String msgType;
		String msgContent;
		
		if (resultCount > 0) {
			msgType = "success";
			msgContent = "정보가 정상적으로 수정되었습니다.";
		} else {
			msgType = "error";
			msgContent = "수정에 실패했습니다. 입력 데이터를 확인해주세요.";
		}
		
		// 3. 리다이렉트 화면까지 안전하게 메시지 배달 (Flash Attribute)
		rttr.addFlashAttribute("msg", msgContent);
		
		// 4. 타일즈 막힘 해결을 위해 GET 메서드로 리다이렉트
		return "redirect:/codemanage";
	}
	
	
	
	@PostMapping("/codelevelupdate")
	public String Codelevelupdate(
			CodeManageDTO CodeManageDTO, 
			RedirectAttributes rttr) { 
		System.out.println("codelevelupdatePost 실행");
		
		// 1. 서비스 실행 (정상 등록 시 1, 실패 시 0 또는 예외 반환)
		int resultCount = codeManageService.CodeLevelUpdate(CodeManageDTO);
		
		// 2. 성패 로직 처리 및 결과 메시지 생성
		String msgType;
		String msgContent;
		
		if (resultCount > 0) {
			msgType = "success";
			msgContent = "권한이 정상적으로 변경되었습니다.";
		} else {
			msgType = "error";
			msgContent = "변경에 실패했습니다. 입력 데이터를 확인해주세요.";
		}
		
		// 3. 리다이렉트 화면까지 안전하게 메시지 배달 (Flash Attribute)
		rttr.addFlashAttribute("msg", msgContent);
		
		// 4. 타일즈 막힘 해결을 위해 GET 메서드로 리다이렉트
		return "redirect:/codemanage";
	}
	
	
	@GetMapping("/codedetail")
	public String CodedetailGet(
			
			 @RequestParam("emp_num") String emp_num, // 💡 <a> 태그가 보낸 파라미터 수집
		        Model model // 💡 JSP(화면)로 데이터를 배달할 가방
		        ) {
		    System.out.println("codedetailGet 실행 - 조회할 ID: " + emp_num);
		    
		    // 서비스에 파라미터로 받은 CodeId를 넘겨서 해당 유저의 상세 정보 조회
		    CodeManageDTO CodeDetail = codeManageService.getCodeDetail(emp_num);
		    
		    //1-2. 서비스에서 부서명 조회
		    List<CodeManageDTO> selectd = codeManageService.selectd();
		    
		    // 1-3. 서비스에서 권한 목록 조회
		    List<CodeManageDTO> selectl = codeManageService.selectl();
		    
		    // 가져온 데이터를 "Code"라는 이름으로 가방(Model)에 넣음
		    model.addAttribute("list", CodeDetail);
		    model.addAttribute("selectd", selectd);
		    model.addAttribute("selectl", selectl);
		    
		    return "content/codedetail.tiles";
		
	}
	
	
	
	
	//paging
	@RequestMapping("/pagingsss")
	public String goStock(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 
		 model.addAttribute("result" , result);
		 model.addAttribute("msg", msg);
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/codemanage";
	}
	
//	@GetMapping("/codesearch")
//	public String CodemanageGet(
//	        CodeManageDTO searchDTO,
//	        Model model
//	        ) { 
//	    System.out.println("codemanageGet 실행 - 검색 조건 진입");
//	    System.out.println("검색 부서: " + searchDTO.getType());
//	    System.out.println("검색 권한: " + searchDTO.getUnit());
//	    System.out.println("검색 키워=드: " + searchDTO.getKeyword());
//
//	    // 1. 서비스에 검색 조건 객체(DTO)를 넘겨 필터링된 결과 조회
//	    List<CodeManageDTO> CodeList = codeManageService.getCodeSearch(searchDTO);
//	    
//	    // 2. 셀렉트 박스들을 채우기 위한 고정 목록 조회
//	    List<CodeManageDTO> selectd = codeManageService.selectd();
//	    List<CodeManageDTO> selectl = codeManageService.selectl();
//	    List<CodeManageDTO> selectm = codeManageService.selectm();
//	    
//	    // 3. 화면에서 검색창에 선택했던 값이 그대로 유지되도록 검색 조건을 다시 뷰로 전달
//	    model.addAttribute("search", searchDTO);
//	    
//	    // 4. 💡 [오타 교정] HTML JSTL 문법(${CodeList})에 맞춰 가방 이름을 대문자로 변경합니다!
//	    model.addAttribute("CodeList", CodeList); 
//	    
//	    model.addAttribute("selectd", selectd);
//	    model.addAttribute("selectl", selectl);
//	    model.addAttribute("selectm", selectm);
//	    
//	    // 5. 타일즈 뷰 리턴
//	    return "content/codemanage.tiles";
//	}
	
	@GetMapping("/codeDisable")
    public String codeDisable(
    		@RequestParam("item_num") int itemNum,
    		RedirectAttributes rttr
    		) {
        System.out.println("비활성화 대상 item_num: " + itemNum);
        
        // 1. 서비스-DAO를 거쳐 DB에 UPDATE item SET item_status = 'N' WHERE item_num = #{itemNum} 실행
        // (서비스에 해당 기능을 담당하는 메서드를 연결해 주셔야 합니다.)
        int result = codeManageService.CodeRetire(itemNum); 
        
        if(result > 0) {
            rttr.addFlashAttribute("msg", "true"); // 팀 표준 등록/수정 성공 알림창 연동
        } else {
            rttr.addFlashAttribute("msg", "false"); // 실패 알림
        }
        
        // 2. 처리가 완전히 끝나면 다시 원래 검색 화면(/codesearch)으로 자동 리다이렉트 시킵니다!
        return "redirect:/codemanage"; 
    }
	
	


}
