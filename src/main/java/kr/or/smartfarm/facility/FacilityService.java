package kr.or.smartfarm.facility;

import java.util.List;
import java.util.Map;


public interface FacilityService {

	public Map selectAll();
	public List ajaxList();
	public List selectLogAll(int page);
	public List searchFM(Map map);
	public List selectEmp();
	public List searchFacility(Map map);
	public int insertFacility(FacilityDTO dto);
	public int updateRandom();
}
