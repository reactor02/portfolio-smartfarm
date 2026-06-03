package kr.or.smartfarm.shipment;

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

/**
 * 출하 관련 HTTP 요청을 처리하는 컨트롤러.
 *
 * <p>출하 목록/검색/상세 조회와 출하지시(insert)·확정(confirm)·취소(cancel)를 담당한다.
 * 확정/취소의 실제 트랜잭션·방어 로직은 {@link ShipmentService}에 위임하며,
 * 컨트롤러는 재고 부족 예외를 {@code ?error=stock} 파라미터로 화면에 surface 한다.</p>
 *
 * URL 패턴: /shipment, /shipmentDetail/{id}, /insertShipment,
 *           /confirmShipment, /cancelShipment, /searchShipment, /loadPendingRequests
 */
@Controller
public class ShipmentController {

    /** 출하 비즈니스 로직 서비스 */
    @Autowired
    ShipmentService shipmentService;

    @RequestMapping("/shipment")
    public String shipmentList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        List result = shipmentService.selectAll(page);
        model.addAttribute("result", result);

        PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
        model.addAttribute("pageInfo", pageInfo);

        model.addAttribute("itemList",    shipmentService.loadItems());
        model.addAttribute("empList",     shipmentService.loadEmpList());
        model.addAttribute("workerList",  shipmentService.loadWorkerList());

        return "content/shipment.tiles";
    }

    @RequestMapping("/loadPendingRequests")
    @ResponseBody
    public List loadPendingRequests() {
        return shipmentService.loadPendingRequests();
    }

    @PostMapping("/insertShipment")
    public String insertShipment(
            @RequestParam("shipmentRequestNum") String shipmentRequestNum,
            @RequestParam("itemNum")            int    itemNum,
            @RequestParam("shipmentDate")       String shipmentDate,
            @RequestParam("planQty")            int    planQty,
            @RequestParam(value = "workerNum", defaultValue = "0") int workerNum,
            HttpSession session) {

        // [권한] e_level 2 이상(팀장·사장)만 등록 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getE_level() < 2) {
            return "redirect:/shipment?error=forbidden";
        }

        // [권한] 로그인 사용자를 담당자로 자동 설정
        int empNum = 1;
        try {
            empNum = Integer.parseInt(loginUser.getEmp_num());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // [방어] 계획 수량이 0 이하면 LOT 배정·재고 차감이 무의미하므로 등록을 막는다.
        if (planQty <= 0) {
            return "redirect:/shipment";
        }

        Map map = new HashMap();
        map.put("shipment_request_num", shipmentRequestNum);
        map.put("item_num",      itemNum);
        map.put("plan_qty",      planQty);
        map.put("emp_num",       empNum);
        map.put("worker_num",    workerNum > 0 ? workerNum : null);
        map.put("shipment_date", shipmentDate);

        shipmentService.dispatchShipment(map);
        int shipmentNum = (Integer) map.get("shipment_num");
        String shipmentId = "SHIP" + String.format("%04d", shipmentNum);
        return "redirect:/shipmentDetail/" + shipmentId;
    }

    @RequestMapping("/shipmentDetail/{shipmentId}")
    public String shipmentDetail(
            @PathVariable("shipmentId") String shipmentId,
            Model model, HttpSession session) {

        Map detail = shipmentService.selectDetail(shipmentId);
        model.addAttribute("detail", detail);

        // [방어] detail이 null이거나 SHIPMENT_NUM 컬럼이 null이면 캐스팅에서 NPE 발생.
        //        두 경우 모두 LOT 조회가 불가능하므로 안전하게 건너뛴다(JSP가 '정보 없음' 처리).
        if (detail != null && detail.get("SHIPMENT_NUM") != null) {
            int shipmentNum = ((Number) detail.get("SHIPMENT_NUM")).intValue();
            List lots = shipmentService.selectLots(shipmentNum);
            model.addAttribute("lots", lots);
        }

        // 취소 권한: e_level >= 3(사장) 또는 담당자 본인
        // 출하확정 권한: 담당자 또는 실무자 본인
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        boolean canCancel  = false;
        boolean canConfirm = false;
        if (loginUser != null) {
            String me = loginUser.getEmp_num();
            String recordEmpNum    = shipmentService.getEmpNum(shipmentId);    // 담당자
            String recordWorkerNum = shipmentService.getWorkerNum(shipmentId); // 실무자
            canCancel  = loginUser.getE_level() >= 3
                      || (me != null && me.equals(recordEmpNum));
            canConfirm = me != null && (me.equals(recordEmpNum) || me.equals(recordWorkerNum));
        }
        model.addAttribute("canCancel",  canCancel);
        model.addAttribute("canConfirm", canConfirm);

        return "content/shipmentDetail.tiles";
    }

    @RequestMapping("/searchShipment")
    @ResponseBody
    public Map searchShipment(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "status", defaultValue = "") String status,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            @RequestParam(value = "sDate", defaultValue = "") String sDate,
            @RequestParam(value = "eDate", defaultValue = "") String eDate,
            @RequestParam(value = "item_num", defaultValue = "0") int itemNum,
            @RequestParam(value = "sort", defaultValue = "reg") String sort) {

        Map result = new HashMap();
        try {
            Map searchMap = new HashMap();
            searchMap.put("page", page);
            searchMap.put("status", status);
            searchMap.put("keyword", keyword);
            searchMap.put("sort", sort);
            // [방어] 날짜 형식이 YYYY-MM-DD가 아니면 TO_DATE() 에서 Oracle 오류 발생.
            //        잘못된 형식이면 빈 문자열로 대체하여 날짜 필터 없이 검색한다.
            if (!sDate.matches("\\d{4}-\\d{2}-\\d{2}")) sDate = "";
            if (!eDate.matches("\\d{4}-\\d{2}-\\d{2}")) eDate = "";
            searchMap.put("sDate", sDate);
            searchMap.put("eDate", eDate);
            searchMap.put("item_num", itemNum);

            List searchResult = shipmentService.searchShipment(searchMap);
            result.put("searchResult", searchResult);
            result.put("status", "good");

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

    @PostMapping("/confirmShipment")
    public String confirmShipment(
            @RequestParam("shipmentNum")        int    shipmentNum,
            @RequestParam("shipmentId")         String shipmentId,
            @RequestParam("shipmentRequestNum") String shipmentRequestNum,
            HttpSession session) {

        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        // [권한] 담당자 또는 실무자 본인만 출하확정 가능
        String me              = loginUser.getEmp_num();
        String recordEmpNum    = shipmentService.getEmpNum(shipmentId);    // 담당자
        String recordWorkerNum = shipmentService.getWorkerNum(shipmentId); // 실무자
        if (me == null || !(me.equals(recordEmpNum) || me.equals(recordWorkerNum))) {
            return "redirect:/shipmentDetail/" + shipmentId + "?error=forbidden";
        }

        int empNum = 1;
        try {
            empNum = Integer.parseInt(loginUser.getEmp_num());
        } catch (Exception e) {
            e.printStackTrace();
        }

        Map map = new HashMap();
        map.put("shipment_num",        shipmentNum);
        map.put("shipment_request_num", shipmentRequestNum);
        map.put("emp_num",             empNum);

        // [방어] 확정 중 재고 부족(stock_error) 등 예외 발생 시 트랜잭션은 롤백되며,
        //        화면에 알림을 띄우기 위해 error 파라미터를 붙여 상세 페이지로 redirect.
        try {
            shipmentService.confirmShipment(map);
        } catch (RuntimeException e) {
            return "redirect:/shipmentDetail/" + shipmentId + "?error=stock";
        }
        return "redirect:/shipmentDetail/" + shipmentId;
    }

    @PostMapping("/cancelShipment")
    public String cancelShipment(
            @RequestParam("shipmentNum")        int    shipmentNum,
            @RequestParam("shipmentId")         String shipmentId,
            @RequestParam("shipmentRequestNum") String shipmentRequestNum,
            HttpSession session) {

        // [권한] e_level >= 3(사장) 또는 담당자 본인만 취소 가능
        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";
        String recordEmpNum = shipmentService.getEmpNum(shipmentId);
        boolean allowed = loginUser.getE_level() >= 3
                       || loginUser.getEmp_num().equals(recordEmpNum);
        if (!allowed) return "redirect:/shipmentDetail/" + shipmentId + "?error=forbidden";

        Map map = new HashMap();
        map.put("shipment_num",        shipmentNum);
        map.put("shipment_request_num", shipmentRequestNum);

        shipmentService.cancelShipment(map);
        return "redirect:/shipmentDetail/" + shipmentId;
    }
}
