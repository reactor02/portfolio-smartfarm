package kr.or.smartfarm.vender;

import java.util.List;
import java.util.Map;

public interface VenderService {

	List<VenderDTO> getVenderList(int pageNum);
	VenderDTO getVender(int vender_num);
	
	void insertVender(VenderDTO venderDTO);
	int updateVender(VenderDTO venderDTO);
	int deleteVender(VenderDTO venderDTO);
	
	public List<VenderDTO> getEmpList();
	
	// 아이디로 찾기 
	VenderDTO findById(int vender_num);
	
	// 검색
	List<VenderDTO> search(Map map);
	

	
}
