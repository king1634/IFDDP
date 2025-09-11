package Repository.adg;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import Dto.adg.FacilityDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class FacilityRepositoryImpl implements FacilityRepository {
	private final SqlSession sqlSession;

	@Override
	public List<FacilityDto> getAllFacility() {
		List<FacilityDto> facilityDtos = null;
		
		try {
//			int dbVersion = sqlSession.selectOne("Facility.getAllFacility");
			facilityDtos = sqlSession.selectList("Facility.getAllFacility");
			
			System.out.println(facilityDtos);
		}
		catch (Exception e) {
			// TODO: handle exception
			System.out.println("TT");
		}

		return facilityDtos;
	}

}
