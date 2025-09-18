package Service.kkm;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import Dto.adg.FacilityDto;
import Repository.kkm.AgingPatternRepository;
import lombok.RequiredArgsConstructor;

@Transactional
@RequiredArgsConstructor
@Service
public class AgingPatternServiceImpl implements AgingPatternService {
	
	private final AgingPatternRepository agingPatternRepository;
	
	@Override
	public List<FacilityDto> findDots(Integer facilityType) {
		
	List<FacilityDto> list = agingPatternRepository.findDots(facilityType);
		return list;
	}

}
