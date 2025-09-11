package Service.adg;

import java.util.List;

import org.springframework.stereotype.Service;

import Dto.adg.FacilityDto;
import Repository.adg.FacilityRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FacilityServiceImpl implements FacilityService {
	private final FacilityRepository facilityRepository;

	@Override
	public List<FacilityDto> getAllFacility(int page, int size) {
		
		return facilityRepository.getAllFacility(page, size);
	}
	
}
