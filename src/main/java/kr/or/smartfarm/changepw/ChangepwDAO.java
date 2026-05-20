package kr.or.smartfarm.changepw;

import java.util.List;

public interface ChangepwDAO {
	
	public int changepw(ChangepwDTO changepwDTO);
	public ChangepwDTO searchpw(ChangepwDTO changepwDTO);

}
