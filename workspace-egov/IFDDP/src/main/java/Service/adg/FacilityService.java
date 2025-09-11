package Service.adg;

import java.util.List;

import Dto.adg.FacilityDto;

public interface FacilityService {
	// 모든 시설물 조회
	List<FacilityDto> getAllFacility(int page, int size);
}
