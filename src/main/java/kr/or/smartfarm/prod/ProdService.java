package kr.or.smartfarm.prod;

import java.util.List;

import org.springframework.stereotype.Service;

@Service
public interface ProdService {
	public List<ProdDTO> getList(ProdPageDTO page);

}
