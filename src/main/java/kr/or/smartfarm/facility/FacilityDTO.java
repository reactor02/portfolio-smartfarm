package kr.or.smartfarm.facility;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import lombok.Data;

@Data
public class FacilityDTO {

	/////////////////////////////
	// facility
	/////////////////////////////
	private int facility_num;
    private String facility_name;
    private int area;

    	//기준값
    private Double m_temperature;
    private Double m_humidity;
    private Double m_soil_ec;
    private Double m_soil_ph;
    private Integer m_illuminance;

    /////////////////////////////
    // facility_management
    /////////////////////////////
    
    private int facility_management_num;

    	//현재값
    private Double temperature;
    private Double humidity;
    private Double soil_ec;
    private Double soil_ph;
    private Integer illuminance;

    private Date managed_at;
    private String facility_chk;
    
    /////////////////////////////
    // facility_management
    /////////////////////////////

    private int censor_num;

	//현재값
	private Double c_temperature;
	private Double c_humidity;
	private Double c_soil_ec;
	private Double c_soil_ph;
	private Integer c_illuminance;

    // emp
    private int emp_num;
    private String ename;
    
}