package kr.or.smartfarm.prod;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/prod")
public class ProdController {

    @Autowired
    ProdService prodService;

    /* ── 목록 ───────────────────────────────────────── */
    @RequestMapping
    public String list(@ModelAttribute ProdPageDTO pageDTO, Model model) {
        List<ProdDTO>         list         = prodService.getList(pageDTO);
        List<SelectOptionDTO> facilityList = prodService.getFacilityOptions();
        List<SelectOptionDTO> itemList     = prodService.getItemOptions();
        List<SelectOptionDTO> empList      = prodService.getEmpList();

        model.addAttribute("list",         list);
        model.addAttribute("page",         pageDTO);
        model.addAttribute("facilityList", facilityList);
        model.addAttribute("itemList",     itemList);
        model.addAttribute("empList",      empList);
        return "content/prod.tiles";
    }

    /* ── 상세 ───────────────────────────────────────── */
    @RequestMapping("/{plan_id}")
    public String detail(@PathVariable String plan_id, Model model,
                         HttpServletRequest request, HttpServletResponse response) throws IOException {
        ProdDTO prodDTO = prodService.selectOne(plan_id);
        if (prodDTO == null) {
            String url = request.getContextPath() + "/prod";
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<script>" +
                "alert('해당 상세페이지가 존재하지 않습니다.');" +
                "location.href='" + url + "';" +
                "</script>"
            );
            return null;
        }
        model.addAttribute("prodDTO",  prodDTO);
        model.addAttribute("empList",  prodService.getEmpList());
        return "content/prodDetail.tiles";
    }

    /* ── 등록 POST ─────────────────────────────────── */
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public String create(@ModelAttribute ProdDTO prodDTO) {
        prodService.create(prodDTO);
        return "redirect:/prod/" + prodDTO.getPlan_id();
    }

    /* ── 취소 POST (AJAX) ─────────────────────────── */
    @RequestMapping(value = "/{plan_id}/cancel", method = RequestMethod.POST)
    @ResponseBody
    public String cancel(@PathVariable String plan_id) {
        prodService.updateStatus(plan_id, "취소");
        return "ok";
    }

    /* ── 작업 이력 AJAX GET ────────────────────────── */
    @RequestMapping(value = "/{plan_id}/work-orders", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> workOrders(@PathVariable String plan_id,
                                          @RequestParam(defaultValue = "1") int page) {
        ProdDTO prodDTO = prodService.selectOne(plan_id);
        if (prodDTO == null) {
            java.util.Map<String, Object> err = new java.util.HashMap<String, Object>();
            err.put("list", new java.util.ArrayList<>());
            err.put("totalPages", 0);
            err.put("currentPage", 1);
            return err;
        }
        return prodService.getWorkOrders(prodDTO.getPlan_num(), page);
    }
}
