package Repository.adg;

import java.util.List;

import Dto.adg.BunryuDto;
import Dto.adg.FacilityDto;

public interface FacilityRepository {
	// 모든 시설물 조회
	List<FacilityDto> getAllFacility(int page, int size);

	// 모든 시설물 종류
	List<BunryuDto> getAllFacilityType();
}
