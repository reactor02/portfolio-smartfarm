package kr.or.smartfarm.vender;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VenderServiceImpl implements VenderService {

	@Autowired 
	VenderDAO venderDAO;
	

	@Override
	public List<VenderDTO> getVenderList(int pageNum) {
		List<VenderDTO> result = venderDAO.selectAllVender(pageNum);
		return result;
	}


	@Override
	public VenderDTO getVender(int vender_num) {
		VenderDTO venderDTO = venderDAO.selectOneVender(vender_num);
		return venderDTO;
	}


	@Override
	public void insertVender(VenderDTO venderDTO) {
		venderDAO.insertVender(venderDTO);
		
	}


	@Override
	public int updateVender(VenderDTO venderDTO) {
		int result = -1; 
		
		result = venderDAO.updateVender(venderDTO);
		return result;
	}


	@Override
	public int deleteVender(VenderDTO venderDTO) {
		int result = -1;
		
		result = venderDAO.deleteVender(venderDTO);
		return result;
	}


	@Override
	public List<VenderDTO> getEmpList() {
		
		return venderDAO.getEmpList();
	}


	@Override
	public VenderDTO findById(int vender_num) {
		VenderDTO venderDTO = null; 
		venderDTO = venderDAO.findById(vender_num);
		return venderDTO;
	}




}
