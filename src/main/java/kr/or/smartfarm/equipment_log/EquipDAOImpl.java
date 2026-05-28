package kr.or.smartfarm.equipment_log;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

import kr.or.smartfarm.stock.StockDTO;

@Repository
public class EquipDAOImpl implements EquipDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	// LIST
	@Override
	public List<EquipDTO> selectAll(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		List<EquipDTO> result = sqlSession.selectList("mapper.equip.selectAllEquip");
		
		return result;
//		int total_runtime = sqlSession.update("mapper.equip.total_runtime");
	}
	
	// SEARCH > LIST
	@Override
	public List searchEquip(Map map) {
		List result = null;
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 10);
		result = sqlSession.selectList("mapper.equip.searchEquip", map);
		return result;
	}

	// SELECT ITEM CODE, NAME
	@Override
	public List selectItemEquip() {
		return sqlSession.selectList("mapper.equip.selectItemEquip");
	}
	// SELECT EMP_NUM, ENAME
	@Override
	public List selectEmp() {
		return sqlSession.selectList("mapper.equip.selectEmp");
	}


	
	// INSERT
	public int insertEquip(EquipDTO dto) {
		return sqlSession.insert("mapper.equip.insertEquip", dto);
	}
	
	
	
}
