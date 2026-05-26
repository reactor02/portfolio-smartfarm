package kr.or.smartfarm.vender;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VenderMapper {
	
	void insert(VenderDTO venderDTO);
	
	VenderDTO findById(int vender_num);
}
