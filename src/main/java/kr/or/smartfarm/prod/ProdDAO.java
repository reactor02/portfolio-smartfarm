package kr.or.smartfarm.prod;

import java.util.List;

public interface ProdDAO {
		
	
	public List<ProdDTO> getList(ProdPageDTO page);
	
}
