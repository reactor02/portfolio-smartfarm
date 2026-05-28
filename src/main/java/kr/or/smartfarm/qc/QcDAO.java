package kr.or.smartfarm.qc;

import java.util.List;
import java.util.Map;



public interface QcDAO {
	
	public List selectAll(int pageNum); 
	public List selectItem(); 
	public List selectWaiting(); 
	public List searchQc(Map map);
	public QcDTO selectDetail(int io_num);
//	public int insertQc(QcDTO dto);
}
