package kr.or.smartfarm.work;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/work")
public class WorkController {

    @Autowired
    WorkService workService;

    /* ── 목록 ───────────────────────────────────────── */
    @RequestMapping
    public String list(@ModelAttribute WorkPageDTO pageDTO, Model model) {
        List<WorkDTO>         list     = workService.getList(pageDTO);
        List<SelectOptionDTO> empList  = workService.getEmpOptions();
        List<SelectOptionDTO> planList = workService.getPlanOptions();
        model.addAttribute("list",     list);
        model.addAttribute("page",     pageDTO);
        model.addAttribute("empList",  empList);
        model.addAttribute("planList", planList);
        return "content/work.tiles";
    }

    /* ── 상세 ───────────────────────────────────────── */
    @RequestMapping("/{work_order_id}")
    public String detail(@PathVariable String work_order_id, Model model,
                         HttpServletRequest request, HttpServletResponse response) throws IOException {
        WorkDTO workDTO = workService.selectOne(work_order_id);
        if (workDTO == null) {
            String url = request.getContextPath() + "/work";
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<script>" +
                "alert('해당 작업지시가 존재하지 않습니다.');" +
                "location.href='" + url + "';" +
                "</script>"
            );
            return null;
        }
        model.addAttribute("workDTO", workDTO);
        return "content/workDetail.tiles";
    }

    /* ── 등록 POST → 상세로 redirect ───────────────── */
    @RequestMapping(method = RequestMethod.POST)
    public String insert(@ModelAttribute WorkDTO workDTO) {
        workService.create(workDTO);
        return "redirect:/work/" + workDTO.getWork_order_id();
    }

    /* ── 취소 POST (AJAX) ─────────────────────────── */
    @RequestMapping(value = "/{work_order_id}/cancel", method = RequestMethod.POST)
    @ResponseBody
    public String cancel(@PathVariable String work_order_id) {
        workService.cancel(work_order_id);
        return "ok";
    }

    /* ── 작업시작 POST (AJAX): WAIT → IN_PROGRESS ── */
    @RequestMapping(value = "/{work_order_id}/start", method = RequestMethod.POST)
    @ResponseBody
    public String start(@PathVariable String work_order_id) {
        workService.start(work_order_id);
        return "ok";
    }

    /* ── 작업종료 POST (AJAX): IN_PROGRESS → DONE ── */
    @RequestMapping(value = "/{work_order_id}/complete", method = RequestMethod.POST)
    @ResponseBody
    public String complete(@PathVariable String work_order_id) {
        workService.complete(work_order_id);
        return "ok";
    }

    /* ── 작업등록 POST (AJAX): current_qty=order_qty, order_end=SYSDATE, status=DONE ── */
    @RequestMapping(value = "/{work_order_id}/produce", method = RequestMethod.POST)
    @ResponseBody
    public String produce(@PathVariable String work_order_id) {
        workService.produce(work_order_id);
        return "ok";
    }
}
