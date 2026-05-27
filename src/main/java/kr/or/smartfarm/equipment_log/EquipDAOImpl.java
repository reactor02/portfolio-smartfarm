package kr.or.smartfarm.equipment_log;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class EquipDAOImpl implements EquipDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<EquipDTO> selectAll(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		
		List<EquipDTO> result = sqlSession.selectList("mapper.equip.selectAllEquip");
		
		return result;
	}
	
}
