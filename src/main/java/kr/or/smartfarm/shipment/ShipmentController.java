package kr.or.smartfarm.shipment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;

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

        return "content/shipment.tiles";
    }

    @RequestMapping("/searchShipment")
    @ResponseBody
    public Map searchShipment(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "status") String status,
            @RequestParam(value = "keyword") String keyword,
            @RequestParam(value = "sDate") String sDate,
            @RequestParam(value = "eDate") String eDate) {

        Map result = new HashMap();

        try {
            Map searchMap = new HashMap();
            searchMap.put("page", page);
            searchMap.put("status", status);
            searchMap.put("keyword", keyword);
            searchMap.put("sDate", sDate);
            searchMap.put("eDate", eDate);

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
}
