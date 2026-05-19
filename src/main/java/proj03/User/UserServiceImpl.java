package proj03.User;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService{
	
	@Override
	public List<UserDTO> user() {
		List<UserDTO> list = new ArrayList<UserDTO>();
		
		return list;
	}

}
