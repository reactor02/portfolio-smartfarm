package kr.or.smartfarm.codemanage;

import java.util.List;

public interface CodeManageDAO {
	
	public List<CodeManageDTO> getCodeManage(int page);
	public List<CodeManageDTO> getCodeSearch(CodeManageDTO searchDTO);
	public List<CodeManageDTO> selectd();
	public List<CodeManageDTO> selectl();
	public List<CodeManageDTO> selectm();
	public int CodeInsert(CodeManageDTO CodeManageDTO);
	public int CodeUpdate(CodeManageDTO CodeManageDTO);
	public int CodeRetire(int itemNum);
	public int CodeLevelUpdate(CodeManageDTO CodeManageDTO);
	public CodeManageDTO getCodeDetail(String CodeId);
	public CodeManageDTO searchpw(CodeManageDTO changepwDTO);

}
