package kr.or.smartfarm.usermanage;

import java.util.HashMap;
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
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class UserManageController {
	
	
	@Autowired
	UserManageService userManageService;
	
	
	
	@GetMapping("/usermanage")
	public String usermanageGet(
	        // 💡 다른 팀원들이 쓰는 규칙에 맞춰 파라미터명을 'page'로 매핑합니다.
	        @RequestParam(value = "page", required = false, defaultValue = "1") int page, 
	        Model model) { 
	    
	    System.out.println("usermanageGet 실행 - 현재 페이지: " + page);

	    // 1. 5개씩 끊어오도록 PageHelper 세팅 (pageNum 대신 page 변수 사용)
	    PageHelper.startPage(page, 5);
	    
	    // 2. 서비스에서 전체 회원 목록(List) 조회
	    List<UserManageDTO> userList = userManageService.getUserManage(page);
	    
	    // 3. 조회된 userList를 PageInfo 객체로 포장
	    PageInfo<UserManageDTO> pageInfo = new PageInfo(userList);
	    
	    // 4. 부서명, 권한 등 공통 드롭다운 목록 조회
	    List<UserManageDTO> selectd = userManageService.selectd();
	    List<UserManageDTO> selectl = userManageService.selectl();
	    List<UserManageDTO> selectm = userManageService.selectm();
	    
	    // 5. ⭐ 핵심: 다른 팀원들이 쓰는 paging.jsp 내부 변수명인 "pageInfo"로 가방에 넣습니다.
	    model.addAttribute("pageInfo", pageInfo); 
	    
	    // 6. 기존 JSP 화면에서 사용할 데이터들 바인딩
	    model.addAttribute("userList", pageInfo.getList()); // 딱 5개만 담긴 리스트
	    model.addAttribute("selectd", selectd);
	    model.addAttribute("selectl", selectl);
	    model.addAttribute("selectm", selectm);
	    
	    return "content/usermanage.tiles";
	}
	
	@GetMapping("/mypage")
	public String mypageGet(
			  // 1. 세션에서 loginUser 객체를 자동으로 주입받습니다.
	        @SessionAttribute(value = "loginUser", required = false) UserManageDTO loginUser,
			Model model
			) { // 💡 데이터를 담을 가방(Model) 주입
		System.out.println("mypageGet 실행");
		
		// 1-2. 서비스에서 부서명 조회
		List<UserManageDTO> selectd = userManageService.selectd();
		
		// 1-3. 서비스에서 권한 목록 조회
		List<UserManageDTO> selectl = userManageService.selectl();
		
		// 1-3. 서비스에서 전체 회원 목록(List) 조회
		List<UserManageDTO> selectm = userManageService.selectm();
		
		// 1-3. 서비스에서 전체 회원 목록(List) 조회
		List<UserManageDTO> selectw = userManageService.selectw();
		
		// 2. 가져온 회원 목록 데이터를 "userList"라는 이름으로 가방에 넣음
		
		model.addAttribute("selectd", selectd);
		model.addAttribute("selectl", selectl);
		model.addAttribute("selectm", selectm);
		model.addAttribute("selectw", selectw);
		
		// 3. 타일즈 뷰 리턴 (화면이 그려지면서 데이터가 함께 배달됩니다)
		return "content/mypage.tiles";
	}
	
	
	@PostMapping("/userinsert")
	public String userinsert(
			UserManageDTO userManageDTO, 
			RedirectAttributes rttr) { 
	    System.out.println("userinsertPost 실행");
	    
	    // 1. 서비스 실행 (정상 등록 시 1, 실패 시 0 또는 예외 반환)
	    int resultCount = userManageService.userInsert(userManageDTO);
	    
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
	    return "redirect:/usermanage";
	}
	
	@PostMapping("/userupdate")
	public String userupdate(
			UserManageDTO userManageDTO, 
			RedirectAttributes rttr) { 
		System.out.println("userupdatePost 실행");
		
		// 1. 서비스 실행 (정상 등록 시 1, 실패 시 0 또는 예외 반환)
		int resultCount = userManageService.userUpdate(userManageDTO);
		
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
		return "redirect:/usermanage";
	}
	
	@PostMapping("/userRetire")
	@ResponseBody // 💡 중요: 페이지 이동을 막고 "success" 글자 데이터만 그대로 브라우저에 던지겠다는 선언!
	public String userretire(UserManageDTO userManageDTO) { 
	    System.out.println("userretirePost 실행 - 넘어온 사원번호: " + userManageDTO.getEmp_num());
	    
	    // 1. 서비스 실행 (정상 등록 시 1, 실패 시 0)
	    int resultCount = userManageService.userRetire(userManageDTO);
	    
	    // 2. 자바스크립트 fetch가 기다리고 있는 "success" 또는 "fail" 문자열을 반환
	    if (resultCount > 0) {
	        return "success"; // 💡 JS의 if (data === "success") 구문과 매칭됨
	    } else {
	        return "fail";
	    }
	}
	
	@PostMapping("/userlevelupdate")
	public String userlevelupdate(
			UserManageDTO userManageDTO, 
			RedirectAttributes rttr) { 
		System.out.println("userlevelupdatePost 실행");
		
		// 1. 서비스 실행 (정상 등록 시 1, 실패 시 0 또는 예외 반환)
		int resultCount = userManageService.userLevelUpdate(userManageDTO);
		
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
		return "redirect:/usermanage";
	}
	
	
	@GetMapping("/userdetail")
	public String userdetailGet(
			
			 @RequestParam("emp_num") String emp_num, // 💡 <a> 태그가 보낸 파라미터 수집
		        Model model // 💡 JSP(화면)로 데이터를 배달할 가방
		        ) {
		    System.out.println("userdetailGet 실행 - 조회할 ID: " + emp_num);
		    
		    // 서비스에 파라미터로 받은 userId를 넘겨서 해당 유저의 상세 정보 조회
		    UserManageDTO userDetail = userManageService.getUserDetail(emp_num);
		    
		    //1-2. 서비스에서 부서명 조회
		    List<UserManageDTO> selectd = userManageService.selectd();
		    
		    // 1-3. 서비스에서 권한 목록 조회
		    List<UserManageDTO> selectl = userManageService.selectl();
		    
		    // 가져온 데이터를 "user"라는 이름으로 가방(Model)에 넣음
		    model.addAttribute("list", userDetail);
		    model.addAttribute("selectd", selectd);
		    model.addAttribute("selectl", selectl);
		    
		    return "content/userdetail.tiles";
		
	}
	
	
	
	
	//paging
	@RequestMapping("/ssssspaging")
	public String goStock(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 
		 model.addAttribute("result" , result);
		 model.addAttribute("msg", msg);
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/stockSelect";
	}
	
//	@GetMapping("/usersearch")
//	public String usermanageGet(
//			UserManageDTO searchDTO,
//			Model model
//			) { 
//	    System.out.println("usermanageGet 실행 - 검색 조건 진입");
//	    System.out.println("검색 부서: " + searchDTO.getDept_num());
//	    System.out.println("검색 권한: " + searchDTO.getE_level());
//	    System.out.println("검색 키워드: " + searchDTO.getKeyword());
//
//	    // 1. 서비스에 검색 조건 객체(DTO)를 넘겨 필터링된 결과 조회
//	    // 💡 (중요) 기존 getUserManage() 메서드에 searchDTO를 매개변수로 넘기도록 서비스 코드를 수정해야 합니다.
//	    List<UserManageDTO> userList = userManageService.getUserSearch(searchDTO);
//	    
//	    // 2. 셀렉트 박스(부서/권한 등)를 채우기 위한 고정 목록 조회
//	    List<UserManageDTO> selectd = userManageService.selectd();
//	    List<UserManageDTO> selectl = userManageService.selectl();
//	    List<UserManageDTO> selectm = userManageService.selectm();
//	    
//	    // 3. 화면에서 검색창에 선택했던 값이 그대로 유지되도록 검색 조건을 다시 뷰로 전달
//	    model.addAttribute("search", searchDTO);
//	    
//	    // 4. 조회된 데이터들을 가방(Model)에 적재
//	    model.addAttribute("userList", userList);
//	    model.addAttribute("selectd", selectd);
//	    model.addAttribute("selectl", selectl);
//	    model.addAttribute("selectm", selectm);
//	    
//	    // 5. 타일즈 뷰 리턴
//	    return "content/usermanage.tiles";
//	}
	
	@RequestMapping("/usersearch")
	@ResponseBody
	public Map searchStocks(
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "type") Integer type,
	        @RequestParam(value = "level") Integer level,
	        @RequestParam(value = "keyword") String keyword
	        ) {

	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("type", type);
	        searchMap.put("level", level);
	        searchMap.put("keyword", keyword );
	        System.out.println(searchMap);
	        
	        List<UserManageDTO> selectd = userManageService.selectd();
		    List<UserManageDTO> selectl = userManageService.selectl();
		    List<UserManageDTO> selectm = userManageService.selectm();
		    
	        List searchResult = userManageService.searchAjax(searchMap);
	        result.put("searchResult", searchResult);

	        result.put("status", "good");
	        if(searchResult != null) {
	        	PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
	        	result.put("pageInfo", pageInfo);
	        }else {
	        	PageInfo pageInfo = new PageInfo();
	        	result.put("pageInfo", pageInfo);
	        }
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        result.put("status", "error");
	    }
	    
	    return result;
	}
	
	@RequestMapping("/codesearch")
	@ResponseBody
	public Map codesearch(
			  @RequestParam(value = "page", defaultValue = "1") int page,
		        // String으로 변경하고, 값이 없을 때를 대비해 required=false와 기본값(빈값)을 설정합니다.
		        @RequestParam(value = "type", required = false, defaultValue = "") String type,
		        @RequestParam(value = "level", required = false, defaultValue = "") String level,
		        @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword
	        ) {

	    Map result = new HashMap();
	    
	    try {
	        Map searchMap = new HashMap();
	        searchMap.put("page", page);
	        searchMap.put("type", type);
	        searchMap.put("level", level);
	        searchMap.put("keyword", keyword );
	        System.out.println(searchMap);
		    
	        List searchResult = userManageService.codesearch(searchMap);
	        result.put("searchResult", searchResult);

	        result.put("status", "good");
	        if(searchResult != null) {
	        	PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
	        	result.put("pageInfo", pageInfo);
	        }else {
	        	PageInfo pageInfo = new PageInfo();
	        	result.put("pageInfo", pageInfo);
	        }
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        result.put("status", "error");
	    }
	    
	    return result;
	}


}
