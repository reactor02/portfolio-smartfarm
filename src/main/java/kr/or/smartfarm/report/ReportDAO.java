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
}
