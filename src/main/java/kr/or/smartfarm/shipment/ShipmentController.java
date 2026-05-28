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

@Controller
public class ShipmentController {

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

        model.addAttribute("itemList", shipmentService.loadItems());
        model.addAttribute("empList",  shipmentService.loadEmpList());

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
            @RequestParam("empNum")             int    empNum,
            @RequestParam("shipmentDate")       String shipmentDate,
            @RequestParam("planQty")            int    planQty) {

        Map map = new HashMap();
        map.put("shipment_request_num", shipmentRequestNum);
        map.put("item_num",      itemNum);
        map.put("plan_qty",      planQty);
        map.put("emp_num",       empNum);
        map.put("shipment_date", shipmentDate);

        shipmentService.dispatchShipment(map);
        int shipmentNum = (Integer) map.get("shipment_num");
        String shipmentId = "SHIP" + String.format("%04d", shipmentNum);
        return "redirect:/shipmentDetail/" + shipmentId;
    }

    @RequestMapping("/shipmentDetail/{shipmentId}")
    public String shipmentDetail(
            @PathVariable("shipmentId") String shipmentId,
            Model model) {

        Map detail = shipmentService.selectDetail(shipmentId);
        model.addAttribute("detail", detail);

        if (detail != null) {
            int shipmentNum = ((Number) detail.get("SHIPMENT_NUM")).intValue();
            List lots = shipmentService.selectLots(shipmentNum);
            model.addAttribute("lots", lots);
        }

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
            @RequestParam(value = "item_num", defaultValue = "0") int itemNum) {

        Map result = new HashMap();
        try {
            Map searchMap = new HashMap();
            searchMap.put("page", page);
            searchMap.put("status", status);
            searchMap.put("keyword", keyword);
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
        int empNum = 1;
        if (loginUser != null) {
            try { empNum = Integer.parseInt(loginUser.getEmp_num()); } catch (Exception e) { empNum = 1; }
        }

        Map map = new HashMap();
        map.put("shipment_num",        shipmentNum);
        map.put("shipment_request_num", shipmentRequestNum);
        map.put("emp_num",             empNum);

        shipmentService.confirmShipment(map);
        return "redirect:/shipmentDetail/" + shipmentId;
    }

    @PostMapping("/cancelShipment")
    public String cancelShipment(
            @RequestParam("shipmentNum")        int    shipmentNum,
            @RequestParam("shipmentId")         String shipmentId,
            @RequestParam("shipmentRequestNum") String shipmentRequestNum) {

        Map map = new HashMap();
        map.put("shipment_num",        shipmentNum);
        map.put("shipment_request_num", shipmentRequestNum);

        shipmentService.cancelShipment(map);
        return "redirect:/shipmentDetail/" + shipmentId;
    }
}
