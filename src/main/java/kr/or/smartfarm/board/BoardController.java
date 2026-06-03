package kr.or.smartfarm.board;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.files.FileDTO;
import kr.or.smartfarm.files.FileService;
import kr.or.smartfarm.login.LoginDTO;

@Controller
@RequestMapping("/board")
public class BoardController {

	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	BoardService boardService;
	
	@Autowired
	FileService fileService;

	@RequestMapping("")
	public String board(@RequestParam(value = "page", defaultValue = "1") int page, Model model) {
		List result = null;
		result = boardService.getBoardList(page);
		
		PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>> (result);
		model.addAttribute("pageInfo", pageInfo);
		
		return "content/board.tiles";
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	@ResponseBody
	public List<BoardDTO> list(@RequestParam(value="page", defaultValue="1") int page) {
	
		System.out.println("/list 실행");

		List<BoardDTO> list = boardService.getBoardList(page);
		System.out.println("BoardController: List: " + list);

		return list;
	}
	
	@GetMapping("/one")
	public String one(int board_num, Model model) {
		System.out.println("/one 실행");
		
		BoardDTO boardDTO = boardService.getBoard(board_num);
		model.addAttribute("boardDTO", boardDTO);
		System.out.println("/one: board_num: "+ board_num);
		
		// 파일 목록 가져오기 
		List<FileDTO> files = fileService.getFiles(board_num);
		model.addAttribute("files", files); 
		
		// 조회수 증가 
		boardService.updateViewCnt(board_num);
		
		return "content/boarddetail.tiles";
	}
	
	@GetMapping("/write")
	public String writeForm() {
		System.out.println("get /write 실행");
	    
		return "content/writeboard.tiles";
	}
	
	@PostMapping("/write")
	public String write(BoardDTO boardDTO, 
						@RequestParam("files") List<MultipartFile> files,
						HttpSession session) {
		System.out.println("post /write 실행");
		
		// 로그인사용자
		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
		
		// DTO에 사번넣기 
		if (loginUser != null) {
			boardDTO.setEmp_num(Integer.parseInt(loginUser.getEmp_num()));
			System.out.println("설정된 작성자 사번 : " + boardDTO.getEmp_num());
		}
		
		// DTO를 서비스에 전달 
		boardService.insertBoard(boardDTO);
		
		int boardID = boardDTO.getBoard_num();
		
		System.out.println("파일 개수: " + files.size());
		
		for(MultipartFile file : files){
		        System.out.println("파일명: " + file.getOriginalFilename());
		    }
		
		for(MultipartFile file : files) {
			if(!file.isEmpty()) {
				//파일 저장 로직
				fileService.save(file, boardID);
			}
		}
		
		
		
		return "redirect:/board";
	}
	
	@GetMapping("/modify")
	public String modifyForm(@RequestParam("board_num") int board_num, Model model) {
		System.out.println("/modify 실행");
		
		BoardDTO board = boardService.findById(board_num);
		
		List<FileDTO> files = fileService.getFiles(board_num);
		
		model.addAttribute("board", board);
		model.addAttribute("files", files);
		model.addAttribute("mode","modify");
		
		return "content/writeboard";
	}
	
	@PostMapping("/modify")
	public String updateBoard(BoardDTO boardDTO, Model model,
								@RequestParam(value="deleteFileIds", required=false) List<Integer> deleteFileIds,
								@RequestParam("files") List<MultipartFile> files) {
		
		System.out.println("/update 실행");
		logger.info("boardDTO :" + boardDTO);
		
		// 내용 수정 
		int result = boardService.updateBoard(boardDTO);
		
		// 삭제 체크된 파일이 있다면 삭제
	    if (deleteFileIds != null) {
	        for (Integer fileNum : deleteFileIds) {
	            fileService.deleteFile(fileNum); // 서비스에 삭제 메서드 필요
	        }
	    }
	    
	    for (MultipartFile file : files) {
	        if (!file.isEmpty()) {
	            fileService.save(file, boardDTO.getBoard_num());
	        }
	    }
		return "redirect:/board";
	}
	
	@RequestMapping("/delete")
	public String deleteBoard(BoardDTO boardDTO, Model model) {
		System.out.println("/delete 실행");
		logger.info("boardDTO :" + boardDTO); 
		
		int result = boardService.deleteBoard(boardDTO);
		
		return "redirect:/board";
	}
	

	@RequestMapping("/search")
	@ResponseBody
	public Map search(
			@RequestParam(value="page", defaultValue="1") int page, 
			@RequestParam(value="type") String type, 
			@RequestParam(value="keyword") String keyword
			) {
		Map result = new HashMap(); 
		
		try {
			Map searchMap = new HashMap(); 
			searchMap.put("page", page);
			searchMap.put("type", type);
			searchMap.put("keyword", keyword);
			System.out.println(searchMap);
			
			List searchResult = boardService.search(searchMap);
			result.put("searchResult", searchResult);
			
			result.put("status",  "good");
			if(searchResult != null) {
				PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
				result.put("pageInfo", pageInfo);
			} else {
				PageInfo pageInfo = new PageInfo(); 
				result.put("pageInfo", pageInfo);
			}
		} catch(Exception e) {
			e.printStackTrace(); 
			result.put("status", "error");
		}
		return result;
	}
	
	@GetMapping("/file/download")
	public ResponseEntity<Resource> download(String fileName) throws Exception {
		
		// 추천: File.separator를 사용하여 OS 독립적으로 작성
		String uploadPath = "D:" + File.separator + "workspace" + File.separator + "workspace_java" 
		                  + File.separator + "Zmartfarm" + File.separator + "src" + File.separator 
		                  + "main" + File.separator + "webapp" + File.separator + "resources" 
		                  + File.separator + "upload" + File.separator;
		File file = new File(uploadPath + fileName);
		
		Resource resource = new InputStreamResource(new FileInputStream(file));
		
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
				.body(resource);
		
	}
	

	
	


}
