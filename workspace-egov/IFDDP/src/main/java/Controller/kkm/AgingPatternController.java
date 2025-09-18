package Controller.kkm;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import Dto.adg.FacilityDto;
import Dto.kkm.FacilityDotsResponseDto;
import Service.kkm.AgingPatternService;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class AgingPatternController {
	private final AgingPatternService agingPatternService;
	
	@GetMapping("agingPattern.do")
	public String startAgingPattern() {
		System.out.println("start");
		return "agingPattern";
	}

	@GetMapping(value = "/agingPatternDots", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<FacilityDotsResponseDto> getDots(
			@RequestParam(name = "facilityType", required = false, defaultValue = "0") Integer facilityType) {
		System.out.println("facilityType-->"+facilityType);
		List<FacilityDto> items = agingPatternService.findDots(facilityType);
		FacilityDotsResponseDto body = FacilityDotsResponseDto.builder().total(items != null ? items.size() : 0).items(items)
				.build();
		return ResponseEntity.ok(body);
	}
	
}
