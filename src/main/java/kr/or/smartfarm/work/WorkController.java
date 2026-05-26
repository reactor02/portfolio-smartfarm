package kr.or.smartfarm.work;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
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

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(java.sql.Date.class, new java.beans.PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                setValue(text == null || text.trim().isEmpty() ? null : java.sql.Date.valueOf(text.trim()));
            }
        });
    }

    /* ── 목록 ───────────────────────────────────────── */
    @RequestMapping
    public String list(@ModelAttribute WorkPageDTO pageDTO, Model model) {
        List<WorkDTO>         list     = workService.getList(pageDTO);
        List<SelectOptionDTO> empList  = workService.getEmpOptions();
        List<SelectOptionDTO> planList = workService.getPlanOptions();
        List<SelectOptionDTO> itemList = workService.getItemOptions();
        model.addAttribute("list",     list);
        model.addAttribute("page",     pageDTO);
        model.addAttribute("empList",  empList);
        model.addAttribute("planList", planList);
        model.addAttribute("itemList", itemList);
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
    public String insert(@ModelAttribute WorkDTO workDTO,
                         HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (workDTO.getOrder_start() == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<script>alert('작업시작일은 필수입니다.'); history.back();</script>");
            return null;
        }
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
        WorkDTO dto = workService.selectOne(work_order_id);
        if (dto == null || dto.getOrder_start() == null) return "error";
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDate orderStart = dto.getOrder_start().toLocalDate();
        if (!today.equals(orderStart)) return "date_error";
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
        try {
            workService.produce(work_order_id);
            return "ok";
        } catch (RuntimeException e) {
            if ("stock_error".equals(e.getMessage())) return "stock_error";
            return "error";
        }
    }

    /* ── 생산계획 검색 AJAX (등록 모달용, 대기/진행만) ── */
    @RequestMapping(value = "/plans", method = RequestMethod.GET)
    @ResponseBody
    public java.util.Map<String, Object> searchPlans(
            @org.springframework.web.bind.annotation.RequestParam(defaultValue = "") String keyword,
            @org.springframework.web.bind.annotation.RequestParam(defaultValue = "1") int page) {
        return workService.searchPlans(keyword, page);
    }
}
