package kr.or.smartfarm.report;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReportDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<ReportSummaryDTO> selectAll(){
		List<ReportSummaryDTO> result = sqlSession.selectList("mapper.report.getReportList");
		return result;
 	}
	
	public List<ReportSummaryDTO> selectQc(){
		List<ReportSummaryDTO> result = sqlSession.selectList("mapper.report.getQcList");
		return result;
	}
	public List<ReportSummaryDTO> selectIO(){
		List<ReportSummaryDTO> result = sqlSession.selectList("mapper.report.getIOList");
		return result;
	}
	
	public List<ReportSummaryDTO> selectProc(){
		List<ReportSummaryDTO> result = sqlSession.selectList("mapper.report.getProcList");
		return result;
	}
	
	public List<ReportSummaryDTO> selectDefective(){
		List<ReportSummaryDTO> result = sqlSession.selectList("mapper.report.getDefectList");
		return result;
	}
	
	public List<ReportSummaryDTO> selectEquip(){
		List<ReportSummaryDTO> result = sqlSession.selectList("mapper.report.getEquipList");
		return result;
	}
}
