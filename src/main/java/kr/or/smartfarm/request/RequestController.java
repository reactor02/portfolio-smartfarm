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

@Controller
public class RequestController {

    @Autowired
    RequestService RequestService;

    @Autowired
    ShipmentService shipmentService;

    @RequestMapping("/request")
    public String requestList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "msg", required = false) String msg,
            Model model) {

        List result = RequestService.selectAll(page);
        model.addAttribute("result", result);

        PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
        model.addAttribute("pageInfo", pageInfo);

        model.addAttribute("itemList", RequestService.loadProducts());

        return "content/request.tiles";
    }

    @RequestMapping("/requestDetail/{requestId}")
    public String requestDetail(
            @PathVariable("requestId") String requestId,
            Model model) {

        Map detail = RequestService.selectDetail(requestId);
        model.addAttribute("detail", detail);

        if (detail != null) {
            String shipmentRequestNum = (String) detail.get("SHIPMENT_REQUEST_NUM");
            int hasShipment = RequestService.hasShipment(shipmentRequestNum);
            model.addAttribute("hasShipment", hasShipment);
            model.addAttribute("linkedShipments", shipmentService.selectByRequestNum(shipmentRequestNum));
        }

        return "content/requestDetail.tiles";
    }

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
            Map searchMap = new HashMap();
            searchMap.put("page", page);
            searchMap.put("type", type);
            searchMap.put("keyword", keyword);
            searchMap.put("status", status);
            searchMap.put("sDate", sDate);
            searchMap.put("eDate", eDate);

            List searchResult = RequestService.searchRequest(searchMap);
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

    @RequestMapping("/searchVender")
    @ResponseBody
    public List searchVender(@RequestParam(value = "keyword", defaultValue = "") String keyword) {
        return RequestService.searchVender(keyword);
    }

    @PostMapping("/insertRequest")
    public String insertRequest(
            @RequestParam("vender_seq")   int    venderSeq,
            @RequestParam("item_num")     int    itemNum,
            @RequestParam("request_date") String requestDate,
            @RequestParam("due_date")     String dueDate,
            @RequestParam(value = "request_qty", defaultValue = "1") int requestQty) {

        Map insertMap = new HashMap();
        insertMap.put("vender_num",   venderSeq);
        insertMap.put("item_num",     itemNum);
        insertMap.put("request_date", requestDate);
        insertMap.put("due_date",     dueDate);
        insertMap.put("request_qty",  requestQty);

        RequestService.insertRequest(insertMap);
        // selectKey로 생성된 shipment_request_num으로 request_id 계산 후 상세 이동
        String shipmentRequestNum = (String) insertMap.get("shipment_request_num");
        String newRequestId = shipmentRequestNum.replace("SREQ", "REQ");
        return "redirect:/requestDetail/" + newRequestId;
    }

    @PostMapping("/cancelRequest")
    public String cancelRequest(
            @RequestParam("shipmentRequestNum") String shipmentRequestNum,
            @RequestParam("requestId")          String requestId) {

        Map cancelMap = new HashMap();
        cancelMap.put("shipment_request_num", shipmentRequestNum);
        cancelMap.put("status_name", "취소");
        RequestService.updateRequestStatus(cancelMap);

        return "redirect:/requestDetail/" + requestId;
    }

    @PostMapping("/dispatchRequest")
    public String dispatchRequest(
            @RequestParam("shipmentRequestNum") String shipmentRequestNum,
            @RequestParam("itemNum")            int    itemNum,
            @RequestParam("requestQty")         int    requestQty,
            @RequestParam("requestId")          String requestId,
            HttpSession session) {

        LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
        int empNum = 1;
        if (loginUser != null) {
            try { empNum = Integer.parseInt(loginUser.getEmp_num()); } catch (Exception e) { empNum = 1; }
        }

        Map dispatchMap = new HashMap();
        dispatchMap.put("shipment_request_num", shipmentRequestNum);
        dispatchMap.put("item_num",  itemNum);
        dispatchMap.put("plan_qty",  requestQty);
        dispatchMap.put("emp_num",   empNum);

        shipmentService.dispatchShipment(dispatchMap);
        // selectKey로 생성된 shipment_num으로 shipment_id 계산 후 출하 상세 이동
        int shipmentNum = (Integer) dispatchMap.get("shipment_num");
        String shipmentId = "SHIP" + String.format("%04d", shipmentNum);
        return "redirect:/shipmentDetail/" + shipmentId;
    }
}
