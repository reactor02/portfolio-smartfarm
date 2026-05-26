package kr.or.smartfarm.vender;

import java.util.List;

public interface VenderService {

	List<VenderDTO> getVenderList(int pageNum);
	VenderDTO getVender(int vender_num);
}
