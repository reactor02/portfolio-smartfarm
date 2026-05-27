package kr.or.smartfarm.board;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

@Controller
@RequestMapping("/board")
public class BoardController {

	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	BoardService boardService;

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
	public String write(BoardDTO boardDTO) {
		System.out.println("post /write 실행");
		
		boardService.insertBoard(boardDTO);
		
		return "redirect:/board";
	}
	
	@GetMapping("/modify")
	public String modifyForm(@RequestParam("board_num") int board_num, Model model) {
		System.out.println("/modify 실행");
		
		BoardDTO board = boardService.findById(board_num);
		
		model.addAttribute("board", board);
		model.addAttribute("mode","modify");
		
		return "content/writeboard";
	}
	
	@PostMapping("/modify")
	public String updateBoard(BoardDTO boardDTO, Model model) {
		System.out.println("/update 실행");
		logger.info("boardDTO :" + boardDTO);
		
		int result = boardService.updateBoard(boardDTO);
		
		return "redirect:/board";
		
	}
	
	@RequestMapping("/delete")
	public String deleteBoard(BoardDTO boardDTO, Model model) {
		System.out.println("/delete 실행");
		logger.info("boardDTO :" + boardDTO); 
		
		int result = boardService.deleteBoard(boardDTO);
		
		return "redirect:/board";
	}
	

	
	
	
	
	

	
	


}
