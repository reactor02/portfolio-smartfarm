package kr.or.smartfarm.comment;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.smartfarm.login.LoginDTO;

@Controller
public class CommentController {
	
	@Autowired
	CommentService commentService;
	
	@GetMapping("/comment/list")
	@ResponseBody
	public List<CommentDTO> list(@RequestParam Integer board_num){
		return commentService.selectList(board_num);
	}
	
	@PostMapping("/comment/write")
	@ResponseBody
	public String writeComment(
			@RequestBody CommentDTO cmtDTO, HttpServletRequest request
			) {
		HttpSession session = request.getSession(false);
		
		// 로그인 체크 
		if(session == null || session.getAttribute("loginUser") == null ) {
			return "login_required";
		}
		
		LoginDTO user = (LoginDTO) session.getAttribute("loginUser");
		
		// 로그인 사용자 정보 넣기 
		cmtDTO.setEmp_num(Integer.parseInt(user.getEmp_num()));
		
		// 댓글 저장 
		int result = commentService.writeComment(cmtDTO);
	
	
		// 결과 반환 
		if(result > 0 ) {
			return "success"; 
		} else {
			return "fail";
		}
		
	}
	
	
	@PostMapping("/comment/delete")
	@ResponseBody
	public String removeComment(@RequestBody CommentDTO cmtDTO, HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		
		// 로그인 체크 
		if(session == null || session.getAttribute("loginUser") == null) {
			return "login_required"; 
		}
		
		LoginDTO user = (LoginDTO) session.getAttribute("loginUser");
		
		// 본인 검증
		cmtDTO.setEmp_num(Integer.parseInt(user.getEmp_num()));
		
		int result = commentService.removeComment(cmtDTO);
		
		return result > 0 ? "success" : "fail";
	}
	
}
