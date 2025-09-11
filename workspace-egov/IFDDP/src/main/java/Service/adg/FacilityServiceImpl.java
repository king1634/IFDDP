package Service.adg;

import org.springframework.stereotype.Service;

import Repository.adg.FacilityRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FacilityServiceImpl implements FacilityService {
	private final FacilityRepository facilityRepositor;
	
}
