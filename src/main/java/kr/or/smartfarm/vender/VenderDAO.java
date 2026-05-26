package kr.or.smartfarm.vender;

import java.util.List;

public interface VenderDAO {

	List<VenderDTO> selectAllVender(int pageNum);
	public VenderDTO selectOneVender(int vender_num);
}
