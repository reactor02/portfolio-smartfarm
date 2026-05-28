package kr.or.smartfarm.codemanage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.smartfarm.login.LoginDTO;
import kr.or.smartfarm.login.SHA256Util;

@Service
public class CodeManageServiceImpl implements CodeManageService {

	@Autowired
	CodeManageDAO CodeManageDAO;

	@Override
	public List<CodeManageDTO> getCodeManage() {
		// TODO Auto-generated method stub

		List<CodeManageDTO> result = CodeManageDAO.getCodeManage();

		return result;

	}
	@Override
	public List<CodeManageDTO> getCodeSearch(CodeManageDTO searchDTO) {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = CodeManageDAO.getCodeSearch(searchDTO);
		
		return result;
		
	}
	@Override
	public List<CodeManageDTO> selectd() {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = CodeManageDAO.selectd();
		
		return result;
		
	}
	@Override
	public List<CodeManageDTO> selectm() {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = CodeManageDAO.selectm();
		
		return result;
		
	}
	@Override
	public int CodeInsert(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
        String pw = SHA256Util.encrypt(CodeManageDTO.getPw());
		
        CodeManageDTO.setPw(pw);
		
		int result = CodeManageDAO.CodeInsert(CodeManageDTO);
		
		return result;
		
	}
	@Override
	public int CodeUpdate(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
		int result = CodeManageDAO.CodeUpdate(CodeManageDTO);
		
		return result;
		
	}
	@Override
	public int CodeRetire(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
		int result = CodeManageDAO.CodeRetire(CodeManageDTO);
		
		return result;
		
	}
	@Override
	public int CodeLevelUpdate(CodeManageDTO CodeManageDTO) {
		// TODO Auto-generated method stub
		
		int result = CodeManageDAO.CodeLevelUpdate(CodeManageDTO);
		
		return result;
		
	}
	@Override
	public List<CodeManageDTO> selectl() {
		// TODO Auto-generated method stub
		
		List<CodeManageDTO> result = CodeManageDAO.selectl();
		
		return result;
		
	}
	@Override
	public CodeManageDTO getCodeDetail(String CodeId) {
		// TODO Auto-generated method stub
		
		CodeManageDTO result = CodeManageDAO.getCodeDetail(CodeId);
		
		return result;
		
	}

	@Override
	public CodeManageDTO searchpw(CodeManageDTO changepwDTO) {
		
		CodeManageDTO result = CodeManageDAO.searchpw(changepwDTO);		
		
		if(result != null && result.getSecret().equals(changepwDTO.getSecret())) {
			return result;
		}		
		
		return null;
	}

}
