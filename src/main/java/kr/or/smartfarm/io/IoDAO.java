package kr.or.smartfarm.io;

import java.util.List;
import java.util.Map;

public interface IoDAO {
	public List selectAll2(int pageNum);
	public List searchIo2(Map map);
	public List facility2();
	public List modalSearch2(String keyword);
	public void insertData2(IoDTO ioDTO);
	
}
