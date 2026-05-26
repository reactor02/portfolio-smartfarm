package kr.or.smartfarm.usermanage;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.github.pagehelper.PageInfo;

@Controller
public class UserManageController {
	
	
	@Autowired
	UserManageService userManageService;
	
	
	
	@GetMapping("/usermanage")
	public String usermanageGet(Model model) { // 💡 데이터를 담을 가방(Model) 주입
	    System.out.println("usermanageGet 실행");

	    // 1. 서비스에서 전체 회원 목록(List) 조회
	    List<UserManageDTO> userList = userManageService.getUserManage();
	    
	    // 1-2. 서비스에서 전체 회원 목록(List) 조회
	    List<UserManageDTO> selectd = userManageService.selectd();
	    
	    // 1-3. 서비스에서 전체 회원 목록(List) 조회
	    List<UserManageDTO> selectl = userManageService.selectl();
	    
	    // 1-3. 서비스에서 전체 회원 목록(List) 조회
	    List<UserManageDTO> selectm = userManageService.selectm();
	    
	    // 2. 가져온 회원 목록 데이터를 "userList"라는 이름으로 가방에 넣음
	    model.addAttribute("userList", userList);
	    model.addAttribute("selectd", selectd);
	    model.addAttribute("selectl", selectl);
	    model.addAttribute("selectm", selectm);
	    
	    // 3. 타일즈 뷰 리턴 (화면이 그려지면서 데이터가 함께 배달됩니다)
	    return "content/usermanage.tiles";
	}
	
	@GetMapping("/userdetail")
	public String userdetailGet(
			
			 @RequestParam("emp_num") String emp_num, // 💡 <a> 태그가 보낸 파라미터 수집
		        Model model // 💡 JSP(화면)로 데이터를 배달할 가방
		        ) {
		    System.out.println("userdetailGet 실행 - 조회할 ID: " + emp_num);
		    
		    // 서비스에 파라미터로 받은 userId를 넘겨서 해당 유저의 상세 정보 조회
		    UserManageDTO userDetail = userManageService.getUserDetail(emp_num);
		    
		    // 가져온 데이터를 "user"라는 이름으로 가방(Model)에 넣음
		    model.addAttribute("list", userDetail);
		    
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
	
	


}
