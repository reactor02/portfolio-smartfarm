package kr.or.smartfarm.qc;

import java.util.List;
import java.util.Map;

public interface QcService {

	public List selectAll(int pageNum);
	public List selectWaiting();
	public List selectItem();
	public List searchQc(Map map);
	public QcDTO selectDetail(int io_num);
	public List selectLog(int io_num);
	public List selectAllQc();
	public QcDTO qcChk(int qc_num);
	public int insertQc1(QcDTO qcDTO);
}
