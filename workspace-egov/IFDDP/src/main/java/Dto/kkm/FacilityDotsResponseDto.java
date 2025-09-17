package Dto.kkm;

import java.util.List;

import Dto.adg.FacilityDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class FacilityDotsResponseDto {
	    private int total; // 총 개체 수
	    private List<FacilityDto> items; // 시설물 정보(시설물 id, 경도, 위도, 주소 등..)
	}

