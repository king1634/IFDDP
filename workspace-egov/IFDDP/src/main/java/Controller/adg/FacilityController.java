package Controller.adg;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import Service.adg.FacilityService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class FacilityController {
	private final FacilityService facilityService;

	@GetMapping("facility")
	public String startAgingPattern() {
		
		
		return "agingPattern";
	}
}
