package Repository.adg;

import java.util.List;

import Dto.adg.DamageDto;

public interface DamageRepository {

	// 시설물 등록
	List<Integer> registDamage(int facilityId, List<DamageDto> damageDtos);
}
