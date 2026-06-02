package kr.or.smartfarm.changepw;

import java.util.List;

public interface ChangepwService {
	
	public int changepw(ChangepwDTO changepwDTO);
	public int updatemp(ChangepwDTO updatempDTO);
	public ChangepwDTO searchpw(ChangepwDTO changepwDTO);

}
