package Service.kkm;

import java.util.List;

import Dto.adg.FacilityDto;

public interface AgingPatternService {

	List<FacilityDto> findDots(Integer facilityType);

}
