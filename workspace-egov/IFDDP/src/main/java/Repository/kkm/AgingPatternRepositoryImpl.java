package Repository.kkm;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import Dto.adg.FacilityDto;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Repository
public class AgingPatternRepositoryImpl implements AgingPatternRepository {
	private final SqlSession session;

	@Override
	public List<FacilityDto> findDots(Integer facilityType) {
		List<FacilityDto> list = session.selectList("AgingPatternDots", facilityType);
		System.out.println("list-->"+list);
		return list;
	}
}
