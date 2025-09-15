package Repository.adg;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import Dto.adg.DamageDto;
import Dto.adg.FacilityDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DamageRepositoryImpl implements DamageRepository {
	private final SqlSession sqlSession;

	@Override
	public List<Integer> registDamage(int facilityId, List<DamageDto> damageDtos) {
		List<Integer> resultList = null;//실패 기본 설정
		int result = 0;
		
		System.out.println(facilityId);
		System.out.println(damageDtos);

		try {
			for(DamageDto damageDto : damageDtos) {
				// 시설물 ID 설정
				damageDto.setFacilityId(facilityId);
				
				// INSERT : 손상
				sqlSession.insert("Damage.insertDamage", damageDto);
				
				resultList.add(damageDto.getDamageId());
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			System.out.println("TT");
			System.out.println(e);
			return resultList;//실패
		}
		
		return resultList;
	}
}
