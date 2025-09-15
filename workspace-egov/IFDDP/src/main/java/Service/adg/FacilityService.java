package Service.adg;

import java.util.List;

import Dto.adg.BunryuDto;
import Dto.adg.FacilityDto;

public interface FacilityService {
	// 모든 시설물 조회
	List<FacilityDto> getAllFacilityAllInfo();
	
	// 범위 시설물 조회
	List<FacilityDto> getAllFacility(int page, int size);
	
	// 모든 시설물 종류
	List<BunryuDto> getAllFacilityType();
	
	// 시설물의 모든 손상 종류
	List<BunryuDto> getDamageTypeOfFacility(int facilityType);
	
	// 시설물 등록
	int registFacility(FacilityDto facilityDto);
}
