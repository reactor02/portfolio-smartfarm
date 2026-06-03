package kr.or.smartfarm.facility;

import java.util.List;
import java.util.Map;


public interface FacilityDAO {
	
	public List selectAll(); 
	public List selectLog(int pageNum); 
	public Integer countAll(); 
	public Integer randomSensor(); 
	public List searchFM(Map map);
	
	
	public List selectItemFacility(); 
	public List selectEmp(); 
	public int insertFM(FacilityDTO facilityDTO); 
	public List searchFacility(Map map);
	public int insertFacility(FacilityDTO dto);
	
}
