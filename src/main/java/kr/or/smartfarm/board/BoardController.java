package kr.or.smartfarm.board;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class BoardController {

	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	BoardService boardService;

	@RequestMapping("/board")
	public String board() {
		return "content/board";
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	@ResponseBody
	public List<BoardDTO> list() {
		System.out.println("/list 실행");

		List<BoardDTO> list = boardService.getBoardList();
		System.out.println("BoardController: List: " + list);

		return list;
	}



}
