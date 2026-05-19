package kr.or.smartfarm.prod;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProdDAOImpl implements ProdDAO  {
	 @Autowired
	   private SqlSession session;    // MyBatis SqlSession 주입
	 
	 @Override
	 public List<ProdDTO> getList(ProdPageDTO page) {
		 
		 List<ProdDTO> list = session.selectList("kr.or.smartfarm.prod.getList", page);
		 System.out.println("list 돌려받기" + list);
	        return list;
	    }
	 

	 
}
