package Repository.kkm;

import java.util.List;

import Dto.adg.FacilityDto;


public interface AgingPatternRepository {

	List<FacilityDto> findDots(Integer facilityType);

}
