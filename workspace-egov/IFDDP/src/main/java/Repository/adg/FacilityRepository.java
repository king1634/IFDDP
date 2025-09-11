package Repository.adg;

import java.util.List;

import Dto.adg.FacilityDto;

public interface FacilityRepository {
	// 모든 시설물 조회
	List<FacilityDto> getAllFacility();
}
