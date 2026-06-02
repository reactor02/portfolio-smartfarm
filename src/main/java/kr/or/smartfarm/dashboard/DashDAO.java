package kr.or.smartfarm.dashboard;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DashDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<DashDTO> selectBoard(){
		List<DashDTO> result = sqlSession.selectList("mapper.dash.getBoardList");
		return result;
	}
	
	public List<DashDTO> selectPS(){
		List<DashDTO> result = sqlSession.selectList("mapper.dash.getPPShipmentList");
		return result;
	}
	
	public List<DashDTO> selectKPIPP(String period, String startDate, String endDate){
		Map<String, Object> param = new HashMap<>();
		param.put("period", period);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		List<DashDTO> result = sqlSession.selectList("mapper.dash.getKPIPP", param);
		return result;
	}
	
	public List<DashDTO> selectKPIShip(String period, String startDate, String endDate){
		Map<String, Object> param = new HashMap<>();
		param.put("period", period);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		List<DashDTO> result = sqlSession.selectList("mapper.dash.getKPIShip", param);
		return result;
	}
	
	public List<DashDTO> selectKPIDefect(String period, String startDate, String endDate){
		Map<String, Object> param =new HashMap<>();
		param.put("period", period);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		List<DashDTO> result = sqlSession.selectList("mapper.dash.getKPIDefect", param);
		return result;
	}
	
	
}
