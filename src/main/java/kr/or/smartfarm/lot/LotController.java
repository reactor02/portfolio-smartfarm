package kr.or.smartfarm.lot;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/lot")
public class LotController {

    @Autowired
    LotService lotService;

    @RequestMapping
    public String list(@ModelAttribute LotPageDTO pageDTO, Model model) {
        List<LotDTO> list = lotService.getList(pageDTO);
        model.addAttribute("list", list);
        model.addAttribute("page", pageDTO);
        return "content/lot.tiles";
    }

    @RequestMapping("/{lot_code}")
    public String detail(@PathVariable String lot_code, Model model,
                         HttpServletRequest request, HttpServletResponse response) throws IOException {
        LotDTO lotDTO = lotService.selectOne(lot_code);
        if (lotDTO == null) {
            String url = request.getContextPath() + "/lot";
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<script>" +
                "alert('해당 LOT가 존재하지 않습니다.');" +
                "location.href='" + url + "';" +
                "</script>"
            );
            return null;
        }
        model.addAttribute("lotDTO", lotDTO);
        return "content/lotDetail.tiles";
    }
}
