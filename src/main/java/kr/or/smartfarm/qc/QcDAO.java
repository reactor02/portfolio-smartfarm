package kr.or.smartfarm.qc;

import java.util.List;
import java.util.Map;



public interface QcDAO {
	
	public List selectAll(int pageNum); 
	public List selectItem(); 
	public List selectEmp(); 
	public List selectWaiting(); 
	public List selectAllQc(); 
	public List searchQc(Map map);
	public QcDTO selectDetail(int io_num);
	public List selectLog(int io_num); 
	public int insertQc1(QcDTO dto);
	public int insertQc2(QcDTO dto);
	public int insertDefect(QcDTO dto);
	public QcDTO qcChk(int qc_num); 
	public QcDTO crrnt_qty(QcDTO dto);
}
