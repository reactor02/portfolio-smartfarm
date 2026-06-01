package kr.or.smartfarm.work;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.smartfarm.login.LoginDTO;

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

/**
 * WorkController - 작업지시(Work Order) 관련 HTTP 요청을 처리하는 컨트롤러.
 *
 * 기본 URL 경로: /work
 *
 * 주요 기능:
 *  - 작업지시 목록 조회 (페이징, 검색 필터)
 *  - 작업지시 상세 조회
 *  - 작업지시 등록 (POST)
 *  - 작업 상태 변경: 취소, 시작(대기→진행), 종료(진행→완료)
 *  - 생산실적 처리 (BOM 기반 재고 차감 + LOT 생성)
 *  - 생산계획 AJAX 검색 (등록 모달용)
 */
@Controller
@RequestMapping("/work")
public class WorkController {

    // WorkService 인터페이스의 구현체(WorkServiceImpl)를 스프링이 자동으로 주입
    @Autowired
    WorkService workService;


    /**
     * 날짜 형식 바인딩 설정.
     * 폼에서 "yyyy-MM-dd" 형식의 문자열을 java.sql.Date 타입으로 자동 변환한다.
     * 빈 문자열이나 null 입력 시 null을 반환하여 NPE를 방지한다.
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
     * GET /work - 작업지시 목록 페이지를 반환한다.
     *
     * @param pageDTO 페이징·필터 정보 (기간, 상태, 품목분류, 품목명, 키워드 등)
     * @param model   JSP에 전달할 데이터 컨테이너
     * @return work.tiles 뷰 (Tiles 레이아웃 적용)
     */
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
    /**
     * GET /work/{work_order_id} - 특정 작업지시의 상세 정보를 조회한다.
     * 존재하지 않는 work_order_id 로 접근 시 JS alert 후 목록으로 리다이렉트한다.
     *
     * @param work_order_id URL 경로에서 추출한 작업지시 ID (예: "PP-2024-001-1")
     * @param model         JSP에 전달할 데이터 컨테이너
     * @param request       컨텍스트 경로 조회에 사용
     * @param response      존재하지 않을 때 HTML+JS 응답 직접 작성에 사용
     * @return workDetail.tiles 뷰, 또는 존재하지 않으면 null (직접 응답 처리)
     */
    @RequestMapping("/{work_order_id}")
    public String detail(@PathVariable String work_order_id, Model model,
                         HttpServletRequest request, HttpServletResponse response,
                         HttpSession session) throws IOException {
        WorkDTO workDTO = workService.selectOne(work_order_id);
        if (workDTO == null) {
            // 잘못된 ID 접근 시 사용자에게 알림을 표시하고 목록으로 이동
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

        // 취소 권한: e_level >= 3(사장) 또는 담당자 본인
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        boolean canCancel = false;
        if (loginUser != null) {
            String recordEmpNum = workService.getEmpNum(work_order_id);
            canCancel = loginUser.getE_level() >= 3
                     || loginUser.getEmp_num().equals(recordEmpNum);
        }
        model.addAttribute("canCancel", canCancel);
        model.addAttribute("workDTO",     workDTO);
        model.addAttribute("processList", workService.getProcessesByItem(workDTO.getItem_num()));
        return "content/workDetail.tiles";
    }

    /* ── 등록 POST → 상세로 redirect ───────────────── */
    /**
     * POST /work - 작업지시를 새로 등록한다.
     * 작업시작일(order_start)이 누락된 경우 JS alert 후 이전 화면으로 돌아간다.
     * 등록 성공 시 생성된 작업지시 상세 페이지로 리다이렉트한다.
     *
     * @param workDTO  폼에서 바인딩된 작업지시 정보 (plan_num, emp_num, order_qty, order_start, content)
     * @return 상세 페이지로 redirect, 또는 유효성 실패 시 null
     */
    @RequestMapping(method = RequestMethod.POST)
    public String insert(@ModelAttribute WorkDTO workDTO,
                         HttpServletRequest request, HttpServletResponse response,
                         HttpSession session) throws IOException {
        // [권한] e_level 2 이상(팀장·사장)만 등록 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getE_level() < 2) {
            return "redirect:/work?error=forbidden";
        }
        if (workDTO.getOrder_start() == null) {
            // 작업시작일 미입력 시 사용자에게 경고 후 이전 페이지로 복귀
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<script>alert('작업시작일은 필수입니다.'); history.back();</script>");
            return null;
        }
        workService.create(workDTO);
        // 등록 후 PRG 패턴: 새로 생성된 작업지시 상세 페이지로 redirect
        return "redirect:/work/" + workDTO.getWork_order_id();
    }

    /* ── 취소 POST (AJAX) ─────────────────────────── */
    /**
     * POST /work/{work_order_id}/cancel - 작업지시를 취소 처리한다. (AJAX)
     * 이미 완료·취소 상태이면 DB 쿼리에서 UPDATE가 무시된다.
     *
     * @param work_order_id 취소할 작업지시 ID
     * @return "ok" (항상 성공 응답)
     */
    @RequestMapping(value = "/{work_order_id}/cancel", method = RequestMethod.POST)
    @ResponseBody
    public String cancel(@PathVariable String work_order_id, HttpSession session) {
        // [권한] e_level >= 3(사장) 또는 담당자 본인만 취소 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "unauthorized";
        String recordEmpNum = workService.getEmpNum(work_order_id);
        boolean allowed = loginUser.getE_level() >= 3
                       || loginUser.getEmp_num().equals(recordEmpNum);
        if (!allowed) return "forbidden";
        workService.cancel(work_order_id);
        return "ok";
    }

    /* ── 작업시작 POST (AJAX): WAIT → IN_PROGRESS ── */
    /**
     * POST /work/{work_order_id}/start - 작업 상태를 '대기'에서 '진행'으로 변경한다. (AJAX)
     *
     * 유효성 검증:
     *  - 작업지시가 존재하지 않거나 작업시작일이 없으면 "error" 반환
     *  - 오늘 날짜가 order_start 와 다르면 "date_error" 반환 (당일 작업만 시작 가능)
     *
     * @param work_order_id 시작할 작업지시 ID
     * @return "ok" | "error" | "date_error"
     */
    @RequestMapping(value = "/{work_order_id}/start", method = RequestMethod.POST)
    @ResponseBody
    public String start(@PathVariable String work_order_id, HttpSession session) {
        // [권한] 담당자 본인만 작업시작 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "unauthorized";
        String recordEmpNum = workService.getEmpNum(work_order_id);
        if (!loginUser.getEmp_num().equals(recordEmpNum)) return "forbidden";
        WorkDTO dto = workService.selectOne(work_order_id);
        if (dto == null || dto.getOrder_start() == null) return "error";
        java.time.LocalDate today      = java.time.LocalDate.now();
        java.time.LocalDate orderStart = dto.getOrder_start().toLocalDate();
        // 작업시작일이 오늘이 아닌 경우 시작 불가
        if (!today.equals(orderStart)) return "date_error";
        workService.start(work_order_id);
        return "ok";
    }

    /* ── 작업종료 POST (AJAX): IN_PROGRESS → DONE ── */
    /**
     * POST /work/{work_order_id}/complete - 작업 상태를 '진행'에서 '완료'로 변경한다. (AJAX)
     * 생산실적 없이 단순 상태만 변경하는 '작업종료' 버튼용이다.
     *
     * @param work_order_id 종료할 작업지시 ID
     * @return "ok"
     */
    @RequestMapping(value = "/{work_order_id}/complete", method = RequestMethod.POST)
    @ResponseBody
    public String complete(@PathVariable String work_order_id, HttpSession session) {
        // [권한] 담당자 본인만 작업완료 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "unauthorized";
        String recordEmpNum = workService.getEmpNum(work_order_id);
        if (!loginUser.getEmp_num().equals(recordEmpNum)) return "forbidden";
        workService.complete(work_order_id);
        return "ok";
    }

    /* ── 작업등록 POST (AJAX): current_qty=order_qty, order_end=SYSDATE, status=DONE ── */
    /**
     * POST /work/{work_order_id}/produce - 생산실적을 처리한다. (AJAX)
     *
     * 내부 처리 흐름 (WorkServiceImpl.produce 참조):
     *  1. 해당 품목의 BOM 재료 목록 조회
     *  2. 재료별 QC 합격 LOT FIFO 차감
     *  3. 각 차감 내역을 io 테이블에 출고 기록
     *  4. 생산된 품목의 신규 LOT 생성
     *  5. work_order 완료 처리 + 생산계획 완료 여부 체크
     *
     * 재고 부족 시 RuntimeException("stock_error")이 발생하며 "stock_error"를 반환한다.
     *
     * @param work_order_id 생산실적을 처리할 작업지시 ID
     * @return "ok" | "stock_error" | "error"
     */
    @RequestMapping(value = "/{work_order_id}/produce", method = RequestMethod.POST)
    @ResponseBody
    public String produce(@PathVariable String work_order_id, HttpSession session) {
        // [권한] 담당자 본인만 생산완료 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "unauthorized";
        String recordEmpNum = workService.getEmpNum(work_order_id);
        if (!loginUser.getEmp_num().equals(recordEmpNum)) return "forbidden";
        try {
            workService.produce(work_order_id);
            return "ok";
        } catch (RuntimeException e) {
            // 재고 부족 시 "stock_error" 반환하여 클라이언트에서 사용자에게 안내
            if ("stock_error".equals(e.getMessage())) return "stock_error";
            return "error";
        }
    }

    /* ── 생산계획 검색 AJAX (등록 모달용, 대기/진행만) ── */
    /**
     * GET /work/plans - 등록 모달에서 사용하는 생산계획 AJAX 검색.
     * 취소·완료 상태의 계획은 제외하고, 페이징(5건/페이지) 처리하여 반환한다.
     *
     * @param keyword 검색어 (계획번호 또는 품목명 부분 일치; 없으면 전체)
     * @param page    요청 페이지 번호 (기본값 1)
     * @return Map { list, currentPage, totalPages, totalCount }
     */
    @RequestMapping(value = "/plans", method = RequestMethod.GET)
    @ResponseBody
    public java.util.Map<String, Object> searchPlans(
            @org.springframework.web.bind.annotation.RequestParam(defaultValue = "") String keyword,
            @org.springframework.web.bind.annotation.RequestParam(defaultValue = "1") int page) {
        return workService.searchPlans(keyword, page);
    }
}
