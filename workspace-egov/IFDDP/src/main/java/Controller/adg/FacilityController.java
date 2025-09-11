package Controller.adg;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import Dto.adg.FacilityDto;
import Service.adg.FacilityService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class FacilityController {
	private final FacilityService facilityService;
	
	@GetMapping("/facilityList.do")
	public String showFacilityList() {
		
		return "facilityManage/facilityList";
	}

	@GetMapping(value = "/facility", produces = "application/json")
    @ResponseBody
	public List<FacilityDto> startAgingPattern() {
		List<FacilityDto> dtos = facilityService.getAllFacility();
		
		return dtos;
	}
}
