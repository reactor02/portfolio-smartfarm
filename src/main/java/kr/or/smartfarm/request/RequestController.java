package kr.or.smartfarm.request;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.login.LoginDTO;
import kr.or.smartfarm.shipment.ShipmentService;

/**
 * 출하요청(주문) 관련 HTTP 요청을 처리하는 컨트롤러 클래스.
 *
 * 주요 기능:
 *   - 출하요청 목록 조회 및 검색
 *   - 출하요청 상세 조회
 *   - 출하요청 등록 (신규 주문 생성)
 *   - 출하요청 취소
 *
 * URL 패턴: /request, /requestDetail/{id}, /searchRequest,
 *           /searchVender, /insertRequest, /cancelRequest
 */
@Controller
public class RequestController {

    /** 출하요청 비즈니스 로직 서비스 */
    @Autowired
    RequestService RequestService;

    /** 출하지시 비즈니스 로직 서비스 (출하지시 실행 및 연계 출하 조회에 사용) */
    @Autowired
    ShipmentService shipmentService;

    /**
     * 출하요청 목록 페이지를 반환한다.
     *
     * 초기 진입 시 전체 목록을 5건씩 페이징하여 모델에 담고,
     * 등록 모달에서 사용할 완제품(PRODUCT) 목록도 함께 전달한다.
     *
     * @param page  현재 페이지 번호 (기본값: 1)
     * @param msg   처리 후 전달될 메시지 파라미터 (현재 화면에 직접 출력하지 않음)
     * @param model 뷰에 전달할 데이터 컨테이너
     * @return content/request.tiles 뷰 이름
     */
    @RequestMapping("/request")
    public String requestList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "msg", required = false) String msg,
            Model model) {

        // 전체 출하요청 목록 조회 (PageHelper가 pageNum 기준으로 5건씩 페이징)
        List result = RequestService.selectAll(page);
        model.addAttribute("result", result);

        // PageHelper가 생성한 PageInfo 객체를 모델에 추가 (JSP에서 페이징 렌더링에 사용)
        PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
        model.addAttribute("pageInfo", pageInfo);

        // 등록 모달의 품목 드롭다운에 사용할 완제품 목록 (type = 'PRODUCT')
        model.addAttribute("itemList", RequestService.loadProducts());

        return "content/request.tiles";
    }

    /**
     * 출하요청 상세 페이지를 반환한다.
     *
     * request_id로 단건 조회 후 해당 요청에 연계된 출하지시 목록도 함께 조회한다.
     *
     * @param requestId URL 경로에서 추출한 요청 ID (예: REQ0001)
     * @param model     뷰에 전달할 데이터 컨테이너
     * @return content/requestDetail.tiles 뷰 이름
     */
    @RequestMapping("/requestDetail/{requestId}")
    public String requestDetail(
            @PathVariable("requestId") String requestId,
            Model model) {

        // 요청 ID로 단건 상세 조회
        Map detail = RequestService.selectDetail(requestId);
        model.addAttribute("detail", detail);

        // [방어] detail이 null이면(없는 요청 ID) 하위 조회를 건너뛰어 NPE를 막는다.
        //        SHIPMENT_REQUEST_NUM이 채워진 경우에만 연계 출하지시를 조회한다.
        if (detail != null) {
            String shipmentRequestNum = (String) detail.get("SHIPMENT_REQUEST_NUM");
            if (shipmentRequestNum != null) {
                // 연계된 출하지시 목록 (상세 페이지 하단 테이블에 표시)
                model.addAttribute("linkedShipments", shipmentService.selectByRequestNum(shipmentRequestNum));
            }
        }

        return "content/requestDetail.tiles";
    }

    /**
     * 출하요청 검색 결과를 JSON으로 반환하는 AJAX 엔드포인트.
     *
     * 상태, 납기일 범위, 키워드를 복합 조건으로 검색하며
     * PageHelper로 페이징 처리된 결과와 PageInfo를 함께 반환한다.
     *
     * @param page    현재 페이지 번호 (기본값: 1)
     * @param type    품목 타입 필터 (현재 UI에서는 빈 문자열로 전송)
     * @param keyword 거래처명 또는 요청번호 검색어
     * @param status  요청 상태 필터 (접수 / 출하대기 / 출하완료 / 취소 / 전체)
     * @param sDate   납기일 검색 시작일 (YYYY-MM-DD)
     * @param eDate   납기일 검색 종료일 (YYYY-MM-DD)
     * @return { status, searchResult, pageInfo } 형태의 Map (JSON 직렬화됨)
     */
    @RequestMapping("/searchRequest")
    @ResponseBody
    public Map searchRequest(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "type", defaultValue = "") String type,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            @RequestParam(value = "status", defaultValue = "") String status,
            @RequestParam(value = "sDate", defaultValue = "") String sDate,
            @RequestParam(value = "eDate", defaultValue = "") String eDate) {

        Map result = new HashMap();
        try {
            // 검색 파라미터를 Map으로 묶어 DAO에 전달
            Map searchMap = new HashMap();
            searchMap.put("page", page);
            searchMap.put("type", type);
            searchMap.put("keyword", keyword);
            searchMap.put("status", status);
            // [방어] 날짜 형식이 YYYY-MM-DD가 아니면 TO_DATE() 에서 Oracle 오류 발생.
            //        잘못된 형식이면 빈 문자열로 대체하여 날짜 필터 없이 검색한다.
            if (!sDate.matches("\\d{4}-\\d{2}-\\d{2}")) sDate = "";
            if (!eDate.matches("\\d{4}-\\d{2}-\\d{2}")) eDate = "";
            searchMap.put("sDate", sDate);
            searchMap.put("eDate", eDate);

            List searchResult = RequestService.searchRequest(searchMap);
            result.put("searchResult", searchResult);
            result.put("status", "good");

            // 검색 결과가 있으면 PageInfo도 함께 반환, 없으면 빈 PageInfo
            if (searchResult != null) {
                PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
                result.put("pageInfo", pageInfo);
            } else {
                result.put("pageInfo", new PageInfo());
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
        }
        return result;
    }

    /**
     * 거래처 검색 결과를 JSON으로 반환하는 AJAX 엔드포인트.
     *
     * 등록 모달의 거래처 드롭다운에서 키워드 입력 시 호출된다.
     * keyword가 빈 문자열이면 전체 거래처를 반환한다.
     *
     * @param keyword 거래처명 검색어 (부분 일치, 대소문자 무시)
     * @return 거래처 목록 (VenderDTO 기반 hashMap 리스트)
     */
    @RequestMapping("/searchVender")
    @ResponseBody
    public List searchVender(@RequestParam(value = "keyword", defaultValue = "") String keyword) {
        return RequestService.searchVender(keyword);
    }

    /**
     * 신규 출하요청을 등록하고 생성된 상세 페이지로 리다이렉트한다.
     *
     * MyBatis selectKey가 SREQ0001 형태의 shipment_request_num을 먼저 생성하고
     * INSERT 후 map에 다시 담아준다. 컨트롤러는 이 값으로 request_id(REQ0001)를 계산해
     * 상세 페이지로 리다이렉트한다.
     *
     * @param venderSeq   거래처 시퀀스 번호
     * @param itemNum     품목 번호
     * @param requestDate 주문일 (YYYY-MM-DD 문자열)
     * @param dueDate     납기일 (YYYY-MM-DD 문자열)
     * @param requestQty  요청 수량 (기본값: 1)
     * @return 생성된 요청의 상세 페이지로 리다이렉트
     */
    @PostMapping("/insertRequest")
    public String insertRequest(
            @RequestParam("vender_seq")   int    venderSeq,
            @RequestParam("item_num")     int    itemNum,
            @RequestParam("request_date") String requestDate,
            @RequestParam("due_date")     String dueDate,
            @RequestParam(value = "request_qty", defaultValue = "1") int requestQty) {

        // [방어] 날짜 필수값 · 형식 검증
        //        비어있거나 YYYY-MM-DD 패턴이 아니면 request.xml의 TO_DATE() 호출 시
        //        Oracle ORA-01847(일 값이 범위를 벗어남) 등의 오류가 500으로 노출된다.
        if (requestDate == null || requestDate.trim().isEmpty()
                || dueDate == null || dueDate.trim().isEmpty()) {
            return "redirect:/request";
        }
        if (!requestDate.matches("\\d{4}-\\d{2}-\\d{2}")
                || !dueDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
            return "redirect:/request";
        }
        // [방어] 수량 0 이하 차단 — 0건 주문은 무의미하며 음수는 재고 증가를 유발할 수 있다.
        if (requestQty <= 0) {
            return "redirect:/request";
        }

        Map insertMap = new HashMap();
        insertMap.put("vender_num",   venderSeq);
        insertMap.put("item_num",     itemNum);
        insertMap.put("request_date", requestDate);
        insertMap.put("due_date",     dueDate);
        insertMap.put("request_qty",  requestQty);

        RequestService.insertRequest(insertMap);
        // selectKey로 생성된 shipment_request_num으로 request_id 계산 후 상세 이동
        // 예: SREQ0001 → REQ0001
        String shipmentRequestNum = (String) insertMap.get("shipment_request_num");
        // [방어] selectKey가 동작하지 않아 번호가 채워지지 않으면 replace()에서 NPE.
        //        이 경우 상세로 갈 식별자가 없으므로 목록으로 안전하게 되돌린다.
        if (shipmentRequestNum == null) {
            return "redirect:/request";
        }
        String newRequestId = shipmentRequestNum.replace("SREQ", "REQ");
        return "redirect:/requestDetail/" + newRequestId;
    }

    /**
     * 출하요청을 취소 상태로 변경하고 상세 페이지로 리다이렉트한다.
     *
     * 취소된 요청은 출하지시를 새로 생성할 수 없다.
     * 이미 완료되었거나 이미 취소된 경우에는 JSP에서 버튼 자체가 표시되지 않는다.
     *
     * @param shipmentRequestNum 출하요청 번호 (SREQ0001 형태)
     * @param requestId          요청 ID (REQ0001 형태, 리다이렉트용)
     * @return 해당 요청의 상세 페이지로 리다이렉트
     */
    @PostMapping("/cancelRequest")
    public String cancelRequest(
            @RequestParam("shipmentRequestNum") String shipmentRequestNum,
            @RequestParam("requestId")          String requestId) {

        Map cancelMap = new HashMap();
        cancelMap.put("shipment_request_num", shipmentRequestNum);
        // status_name으로 status_num을 서브쿼리로 찾아 업데이트 (request.xml 참고)
        cancelMap.put("status_name", "취소");
        RequestService.updateRequestStatus(cancelMap);

        return "redirect:/requestDetail/" + requestId;
    }

}
