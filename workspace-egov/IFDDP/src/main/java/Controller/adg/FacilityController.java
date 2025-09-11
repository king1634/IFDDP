package Controller.adg;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import Dto.adg.FacilityDto;
import Service.adg.FacilityService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class FacilityController {
	private final FacilityService facilityService;
	
	@GetMapping("/facilityList.do")
	public String showFacilityList(Model model) {

		List<FacilityDto> facilityDtos = facilityService.getAllFacility(0, 10);

		model.addAttribute("facilityList", facilityDtos);

		return "facilityManage/facilityList";
	}
	
	@GetMapping(value = "/facility", produces = "application/json")
    @ResponseBody
	public List<FacilityDto> startAgingPattern(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        // 페이지는 1부터 시작하지만, 실제 계산은 0부터 시작해야 함
        int offset = (page - 1) * size;
        
		List<FacilityDto> facilityDtos = facilityService.getAllFacility(offset, size);
		
		return facilityDtos;
	}
}
