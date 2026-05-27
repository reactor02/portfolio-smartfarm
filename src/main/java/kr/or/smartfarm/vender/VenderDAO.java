package kr.or.smartfarm.vender;

import java.util.List;

public interface VenderDAO {

	List<VenderDTO> selectAllVender(int pageNum);
	public VenderDTO selectOneVender(int vender_num);
	
	// insert 
	void insertVender(VenderDTO venderDTO);
	
	// update, delete
	int updateVender(VenderDTO venderDTO);
	int deleteVender(VenderDTO venderDTO);
	
	// emp 테이블 정보 가져오기 
	public List<VenderDTO> getEmpList();
	
	// 아이디로 가져오기 
	public VenderDTO findById(int vender_num);
	
	// 검색용 
	List<VenderDTO> search(VenderDTO venderDTO);
}
