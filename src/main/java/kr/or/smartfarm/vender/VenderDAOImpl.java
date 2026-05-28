package kr.or.smartfarm.vender;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;

@Repository
public class VenderDAOImpl implements VenderDAO{
	
	@Autowired
	SqlSession sqlSession;

	@Override 
	public List<VenderDTO> selectAllVender(int pageNum) {
		
		PageHelper.startPage(pageNum, 10);
		
		List<VenderDTO> resultList = null;
		resultList = sqlSession.selectList("mapper.vender.selectVender");
		System.out.println("dao: resultList: " + resultList);
		
		return resultList;
	}

	@Override
	public VenderDTO selectOneVender(int vender_num) {
		VenderDTO venderDTO = null;
		
		venderDTO = sqlSession.selectOne("mapper.vender.selectOneVender", vender_num);
		System.out.println("selectOneVender: VenderDTO: " + venderDTO);
		return venderDTO;
	}

	@Override
	public void insertVender(VenderDTO venderDTO) {
		sqlSession.insert("mapper.vender.insertVender", venderDTO);
	}

	@Override
	public int updateVender(VenderDTO venderDTO) {
		int result = -1; 
		result = sqlSession.update("mapper.vender.updateVender", venderDTO);
		return result;
	}

	@Override
	public int deleteVender(VenderDTO venderDTO) {
		int result = -1; 
		result = sqlSession.delete("mapper.vender.deleteVender", venderDTO);
		return result;
	}

	@Override
	public List<VenderDTO> getEmpList() {
		
		return sqlSession.selectList("mapper.vender.getEmpList");
	}

	@Override
	public VenderDTO findById(int vender_num) {
		VenderDTO venderDTO = null ;
		venderDTO = sqlSession.selectOne("mapper.vender.findById", vender_num);
		return venderDTO;
	}

	@Override
	public List search(Map map) {
		List resultList = null; 
		
		int pageNum = (Integer)map.get("page");
		PageHelper.startPage(pageNum, 10);
		resultList = sqlSession.selectList("mapper.vender.searchVender", map);
		System.out.println("search : resultList : " + resultList);
		return resultList;
	}



}
