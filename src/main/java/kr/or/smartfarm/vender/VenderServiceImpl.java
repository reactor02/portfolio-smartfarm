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

}
