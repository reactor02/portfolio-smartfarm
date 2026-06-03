package kr.or.smartfarm.qc;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;


@Repository
public class QcDAOImpl implements QcDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<QcDTO> selectAll(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		
		List<QcDTO> result = sqlSession.selectList("mapper.qc.selectAllQc");
		
		return result;
	}

	@Override
	public List selectItem() {
		return sqlSession.selectList("mapper.qc.selectItem");
	}

	// SEARCH > LIST
	@Override
	public List searchQc(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 10);
		result = sqlSession.selectList("mapper.qc.searchQc", map);
		return result;
	}

	@Override
	public List selectWaiting() {
		return sqlSession.selectList("mapper.qc.selectWaiting");
	}

	@Override
	public QcDTO selectDetail(int io_num) {
		return sqlSession.selectOne("mapper.qc.selectDetail", io_num);
	}

	@Override
	public List selectLog(int io_num) {
		return sqlSession.selectList("mapper.qc.selectLog", io_num);
	}
	@Override
	public List selectAllQc() {
		return sqlSession.selectList("mapper.qc.qcList");
	}

	// INSERT
	public int insertQc1(QcDTO dto) {
		return sqlSession.insert("mapper.qc.insertQc1", dto);
	}

	// QC PASS / FAILED 확인
	@Override
	public QcDTO qcChk(int qc_num) {
		return  sqlSession.selectOne("mapper.qc.qcChk", qc_num);
	}
	

	// UPDATE / INSERT2 
	@Override
	public int insertQc2(QcDTO dto) {
		sqlSession.update("mapper.qc.updateIO", dto);
		return sqlSession.insert("mapper.qc.insertQc2", dto);
	}
	
	// INSERT > DEFECTIVE
	@Override
	public int insertDefect(QcDTO dto) {
		return sqlSession.insert("mapper.qc.insertDefect", dto);
	}

	@Override
	public QcDTO crrnt_qty(QcDTO dto) {
		return sqlSession.selectOne("mapper.qc.crrnt_qty", dto);
	}

	@Override
	public List selectEmp() {
		return sqlSession.selectList("mapper.qc.selectEmp");
	}
	
}
