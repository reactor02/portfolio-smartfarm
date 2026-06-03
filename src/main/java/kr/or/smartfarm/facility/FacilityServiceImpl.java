package kr.or.smartfarm.facility;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class FacilityServiceImpl implements FacilityService{

	@Autowired
	FacilityDAO facilityDAO;

	@Override
	public Map selectAll() {
		
		Map result = new HashMap();
		
		// select All
		result.put("list", facilityDAO.selectAll());
		// count All
		result.put("countAll", facilityDAO.countAll());
		
		
		return result; 
	}

	@Override
	public List selectEmp() {
		return facilityDAO.selectEmp();
	}
	
	public List searchFacility(Map map) {
		return facilityDAO.searchFacility(map);
	}
	
	public int insertFacility(FacilityDTO dto) {
		return facilityDAO.insertFacility(dto);
	}

	@Override
	public List selectLogAll(int pageNum) {
		
		List result = new ArrayList();
		result = facilityDAO.selectLog(pageNum);
		
		return result; 
	}

	@Override
	public List searchFM(Map map) {
		return facilityDAO.searchFM(map);
	}

	@Override
	public List ajaxList() {
		// 조회 전달.
		return facilityDAO.selectAll();
	}

	@Override
	public int updateRandom() {
		// 랜덤 트래픽
		return facilityDAO.randomSensor();
	}
	
	public int insertFM(FacilityDTO facilityDTO) {
		return facilityDAO.insertFM(facilityDTO);
	}


}
