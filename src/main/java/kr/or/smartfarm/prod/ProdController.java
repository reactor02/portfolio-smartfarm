package kr.or.smartfarm.prod;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.smartfarm.login.LoginDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 생산계획(Production Plan) 모듈 컨트롤러
 *
 * - 기본 URL: /prod
 * - 생산계획 목록 조회, 상세 조회, 등록, 취소 기능을 처리한다.
 * - 작업지시(work_order) 이력을 AJAX로 제공한다.
 * - 상태 흐름: 대기 → 진행 → 완료 / 취소
 */
@Controller
@RequestMapping("/prod")
public class ProdController {

    // 생산계획 서비스 계층 의존성 주입
    @Autowired
    ProdService prodService;

    /**
     * 날짜 타입 바인딩 설정
     * - 폼에서 "yyyy-MM-dd" 형식의 문자열을 java.sql.Date 로 자동 변환한다.
     * - 빈 문자열이 전달될 경우 null 로 처리한다.
     */
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
    /**
     * 생산계획 목록 페이지 조회
     *
     * - GET /prod
     * - 검색 조건(기간, 상태, 품목 등)을 ProdPageDTO 로 받아 페이징 처리된 목록을 반환한다.
     * - 품목 드롭다운, 담당자 드롭다운 데이터도 함께 모델에 담는다.
     *
     * @param pageDTO  검색 조건 및 페이지 정보 (URL 파라미터 자동 바인딩)
     * @param model    뷰에 전달할 데이터 컨테이너
     * @return "content/prod.tiles" 뷰 이름
     */
    @RequestMapping
    public String list(@ModelAttribute ProdPageDTO pageDTO, Model model) {
        List<ProdDTO>         list     = prodService.getList(pageDTO);
        List<SelectOptionDTO> itemList = prodService.getItemOptions();
        List<SelectOptionDTO> empList  = prodService.getEmpList();

        model.addAttribute("list",     list);
        model.addAttribute("page",     pageDTO);
        model.addAttribute("itemList", itemList);
        model.addAttribute("empList",  empList);
        return "content/prod.tiles";
    }

    /* ── 상세 ───────────────────────────────────────── */
    /**
     * 생산계획 상세 페이지 조회
     *
     * - GET /prod/{plan_id}
     * - plan_id 에 해당하는 생산계획이 없으면 alert 스크립트를 출력하고 목록으로 리다이렉트한다.
     *
     * @param plan_id   URL 경로에서 추출한 생산계획 식별자 (예: "A", "B", ...)
     * @param model     뷰에 전달할 데이터 컨테이너
     * @param request   컨텍스트 경로 조회에 사용
     * @param response  데이터 없음 시 인라인 스크립트 응답 작성에 사용
     * @return "content/prodDetail.tiles" 뷰 이름, 또는 존재하지 않으면 null
     */
    @RequestMapping("/{plan_id}")
    public String detail(@PathVariable String plan_id, Model model,
                         HttpServletRequest request, HttpServletResponse response,
                         HttpSession session) throws IOException {
        ProdDTO prodDTO = prodService.selectOne(plan_id);
        if (prodDTO == null) {
            // 해당 계획이 없을 경우 사용자에게 알림 후 목록 화면으로 이동
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

        // 취소 권한: e_level >= 3(사장) 또는 담당자 본인
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        boolean canCancel = false;
        if (loginUser != null) {
            String recordEmpNum = prodService.getEmpNum(plan_id);
            canCancel = loginUser.getE_level() >= 3
                     || loginUser.getEmp_num().equals(recordEmpNum);
        }
        model.addAttribute("canCancel", canCancel);
        model.addAttribute("prodDTO",  prodDTO);
        model.addAttribute("empList",  prodService.getEmpList());
        return "content/prodDetail.tiles";
    }

    /* ── 등록 POST ─────────────────────────────────── */
    /**
     * 생산계획 신규 등록
     *
     * - POST /prod/create
     * - 폼 데이터를 ProdDTO 로 바인딩하여 서비스에 저장을 요청한다.
     * - 저장 후 생성된 plan_id 의 상세 페이지로 리다이렉트한다.
     *
     * @param prodDTO  등록 폼에서 전달받은 생산계획 데이터
     * @return 등록된 상세 페이지로의 리다이렉트 경로
     */
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public String create(@ModelAttribute ProdDTO prodDTO, HttpSession session) {
        // [권한] e_level 2 이상(팀장·사장)만 등록 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getE_level() < 2) {
            return "redirect:/prod?error=forbidden";
        }
        prodService.create(prodDTO);
        return "redirect:/prod/" + prodDTO.getPlan_id();
    }

    /* ── 취소 POST (AJAX) ─────────────────────────── */
    /**
     * 생산계획 취소 처리 (AJAX)
     *
     * - POST /prod/{plan_id}/cancel
     * - 해당 생산계획의 상태를 "취소"로 변경한다.
     * - @ResponseBody 로 문자열 "ok" 를 반환하여 Ajax 호출 성공 여부를 알린다.
     *
     * @param plan_id  취소할 생산계획 식별자
     * @return "ok" 문자열
     */
    @RequestMapping(value = "/{plan_id}/cancel", method = RequestMethod.POST)
    @ResponseBody
    public String cancel(@PathVariable String plan_id, HttpSession session) {
        // [권한] e_level >= 3(사장) 또는 담당자 본인만 취소 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "unauthorized";
        String recordEmpNum = prodService.getEmpNum(plan_id);
        boolean allowed = loginUser.getE_level() >= 3
                       || loginUser.getEmp_num().equals(recordEmpNum);
        if (!allowed) return "forbidden";
        prodService.updateStatus(plan_id, "취소");
        return "ok";
    }

    /* ── 작업 이력 AJAX GET ────────────────────────── */
    /**
     * 작업지시(work_order) 이력 조회 (AJAX)
     *
     * - GET /prod/{plan_id}/work-orders?page={page}
     * - plan_id 에 해당하는 생산계획의 작업지시 목록을 페이징하여 JSON 으로 반환한다.
     * - plan_id 가 존재하지 않으면 빈 Map 을 반환한다.
     *
     * @param plan_id  생산계획 식별자
     * @param page     조회할 페이지 번호 (기본값: 1)
     * @return list, totalPages, totalCount, currentPage 키를 담은 Map
     */
    @RequestMapping(value = "/{plan_id}/work-orders", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> workOrders(@PathVariable String plan_id,
                                          @RequestParam(defaultValue = "1") int page) {
        ProdDTO prodDTO = prodService.selectOne(plan_id);
        if (prodDTO == null) {
            java.util.Map<String, Object> err = new java.util.HashMap<String, Object>();
//            err.put("list", new java.util.ArrayList<>());
//            err.put("totalPages", 0);
//            err.put("currentPage", 1);
            return err;
        }
        return prodService.getWorkOrders(prodDTO.getPlan_num(), page);
    }
}
