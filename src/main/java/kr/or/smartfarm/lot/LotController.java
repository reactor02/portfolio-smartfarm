package kr.or.smartfarm.lot;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.smartfarm.prod.SelectOptionDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;

/**
 * LOT 관리 컨트롤러
 *
 * <p>LOT(Lot) 이란 동일한 생산 조건으로 만들어진 제품/재료의 묶음 단위입니다.
 * 이 컨트롤러는 "/lot" URL을 기반으로 다음 기능을 제공합니다.</p>
 * <ul>
 *   <li>LOT 목록 조회 (페이징 + 다중 필터)</li>
 *   <li>LOT 상세 조회 (연관관계, 소모자재, 상위투입)</li>
 *   <li>롯이력 AJAX 조회 (생산공정 + 출하이력 통합, 자식 LOT 재귀 포함)</li>
 * </ul>
 *
 * <p>Spring MVC @Controller 로 등록되어 있으며,
 * 화면은 Apache Tiles 레이아웃("*.tiles")을 사용합니다.</p>
 */
@Controller
@RequestMapping("/lot")
public class LotController {

    /** LOT 비즈니스 로직을 담당하는 서비스 레이어 (스프링이 자동 주입) */
    @Autowired
    LotService lotService;

    /**
     * LOT 목록 화면 요청 처리 — GET /lot
     *
     * <p>검색 조건(기간, 품목분류, 품목명, 키워드)과 페이지 번호를 받아
     * LOT 목록과 페이징 정보를 Model에 담아 lot.tiles 뷰로 전달합니다.</p>
     *
     * @param pageDTO  검색 조건 및 페이징 파라미터 (URL 쿼리스트링 자동 바인딩)
     * @param model    뷰에 전달할 데이터 컨테이너
     * @return         Tiles 레이아웃 정의 이름 ("content/lot.tiles")
     */
    @RequestMapping
    public String list(@ModelAttribute LotPageDTO pageDTO, Model model) {
        List<LotDTO>          list     = lotService.getList(pageDTO);
        List<SelectOptionDTO> itemList = lotService.getItemOptions();
        model.addAttribute("list",     list);      // 조회된 LOT 목록
        model.addAttribute("page",     pageDTO);   // 페이징 및 검색 조건 (JSP에서 현재 상태 유지에 사용)
        model.addAttribute("itemList", itemList);  // 품목명 드롭다운 옵션 목록
        return "content/lot.tiles";
    }

    /**
     * LOT 상세 화면 요청 처리 — GET /lot/{lot_code}
     *
     * <p>URL 경로에서 lot_code를 읽어 해당 LOT의 상세 정보를 조회합니다.
     * 존재하지 않는 lot_code로 접근하면 JavaScript alert를 출력하고
     * 목록 페이지로 리다이렉트합니다.</p>
     *
     * <p>정상 조회 시 Model에 다음 데이터를 담습니다.</p>
     * <ul>
     *   <li>lotDTO           : LOT 기본 정보</li>
     *   <li>materials        : 이 LOT 생산에 직접 투입된 소모재료 LOT 목록</li>
     *   <li>usedIn           : 이 LOT이 소모재료로 투입된 상위 생산 LOT 목록</li>
     *   <li>recursiveMaterials : CONNECT BY 재귀로 가져온 전체 소모재료 트리</li>
     * </ul>
     *
     * @param lot_code  URL 경로 변수 — LOT 코드 문자열 (예: LOT-20250529-123)
     * @param model     뷰에 전달할 데이터 컨테이너
     * @param request   컨텍스트 경로 확인에 사용 (리다이렉트 URL 생성)
     * @param response  존재하지 않는 LOT 접근 시 JavaScript alert 응답 작성에 사용
     * @return          Tiles 레이아웃 정의 이름 ("content/lotDetail.tiles"), 존재하지 않으면 null
     * @throws IOException  response.getWriter() 호출 시 발생 가능
     */
    @RequestMapping("/{lot_code}")
    public String detail(@PathVariable String lot_code, Model model,
                         HttpServletRequest request, HttpServletResponse response) throws IOException {
        LotDTO lotDTO = lotService.selectOne(lot_code);
        if (lotDTO == null) {
            // 존재하지 않는 LOT 코드로 직접 URL 접근한 경우 — 목록으로 되돌려 보냄
        	System.out.println("롯 패스배리어블 접속");
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
        model.addAttribute("lotCode", lot_code );
        
        model.addAttribute("lotDTO",             lotDTO);
        // 이 LOT 생산에 사용된 소모재료 LOT (직접 1단계)
        model.addAttribute("materials",          lotService.getMaterialsByChildLot(lotDTO.getLot_num()));
        // 이 LOT이 재료로 투입된 상위 생산 LOT
        model.addAttribute("usedIn",             lotService.getParentsByLot(lotDTO.getLot_num()));
        // CONNECT BY 재귀로 모든 단계의 소모재료 트리 조회
        model.addAttribute("recursiveMaterials", lotService.getRecursiveMaterials(lotDTO.getLot_num()));
        return "content/lotDetail.tiles";
    }

    /**
     * 롯이력 AJAX 요청 처리 — GET /lot/{lot_code}/lotHistory
     *
     * <p>lotDetail.jsp의 "롯이력" 탭을 클릭할 때 JavaScript fetch()가 이 URL을 호출합니다.
     * @ResponseBody 로 JSON 배열을 직접 반환하므로 별도 뷰 파일 없이 데이터만 응답합니다.</p>
     *
     * <p>반환 데이터 구조 (각 행은 Map):</p>
     * <ul>
     *   <li>DEPTH       : 트리 깊이 (0=루트 LOT, 1+=분할된 자식 LOT)</li>
     *   <li>LOT_CODE    : LOT 코드</li>
     *   <li>ITEM_NAME   : 품목명</li>
     *   <li>ITEM_TYPE   : 품목 유형 (PRODUCT, SEMIPRODUCT 등)</li>
     *   <li>GUBUN       : 구분 ("생산공정" 또는 "출하")</li>
     *   <li>ID_COL      : 작업지시 ID 또는 출하 ID</li>
     *   <li>CONTENT_COL : 공정 내용 또는 거래처명</li>
     *   <li>DATE_COL    : 작업 시작일 또는 출하일 (YYYY-MM-DD)</li>
     *   <li>STATUS_COL  : 작업지시 상태 또는 출하 상태</li>
     *   <li>WORKER      : 담당자 이름</li>
     * </ul>
     *
     * @param lot_code  URL 경로 변수 — LOT 코드 문자열
     * @return          롯이력 목록 (JSON 배열). lot_code가 없으면 빈 리스트 반환.
     */
    /* ── 롯이력 AJAX ── */
    @RequestMapping("/{lot_code}/lotHistory")
    @ResponseBody
    public List<Map<String, Object>> lotHistory(@PathVariable String lot_code) {
        LotDTO lotDTO = lotService.selectOne(lot_code);
        // lot_code가 DB에 없으면 빈 배열 반환 (프론트엔드에서 "롯이력이 없습니다" 표시)
        if (lotDTO == null) return Collections.emptyList();
        // lot_code → lot_num 변환 후 이력 조회 (DB 쿼리는 내부 PK인 lot_num 기준)
        return lotService.getLotHistory(lotDTO.getLot_num());
    }
}
