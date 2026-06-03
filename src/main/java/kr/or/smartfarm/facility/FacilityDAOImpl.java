package kr.or.smartfarm.facility;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

import kr.or.smartfarm.qc.QcDTO;
import kr.or.smartfarm.stock.StockDTO;

@Repository
public class FacilityDAOImpl implements FacilityDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	// LIST
	@Override
	public List<FacilityDTO> selectAll() {
		
		List<FacilityDTO> result = sqlSession.selectList("mapper.facility.selectAllFacility");
		
		return result;
	}
	
	@Override
	public List searchFM(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 10);
		result = sqlSession.selectList("mapper.facility.searchFM", map);
		return result;
	}
	
	@Override
	public Integer countAll() {
		return sqlSession.selectOne("mapper.facility.countAll");
	}
	
	// SEARCH > LIST
	@Override
	public List searchFacility(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 10);
		result = sqlSession.selectList("mapper.facility.searchFacility", map);
		return result;
	}

	// SELECT ITEM CODE, NAME
	@Override
	public List selectItemFacility() {
		return sqlSession.selectList("mapper.facility.selectItemFacility");
	}
	// SELECT EMP_NUM, ENAME
	@Override
	public List selectEmp() {
		return sqlSession.selectList("mapper.facility.selectEmp");
	}


	
	// INSERT
	public int insertFacility(FacilityDTO dto) {
		return sqlSession.insert("mapper.facility.insertFacility", dto);
	}

	// Log
	@Override
	public List selectLog(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		List<FacilityDTO> result = sqlSession.selectList("mapper.facility.selectLog");
		
		return result;
		
	}

	@Override
	public Integer randomSensor() {
		return sqlSession.update("mapper.facility.updateSensorRandomly");
	}




	
	
	
}
