package kr.or.smartfarm.prod;

import java.util.List;

public interface ProdDAO {
		
	
	public List<ProdDTO> getList(ProdPageDTO page);
	public List<SelectOptionDTO> getFacilityOptions();
	public List<SelectOptionDTO> getItemOptions();
	
	public ProdDTO getSelectOne(String plan_id);
	
	public int create(ProdDTO prodDTO);
	
}
