package Repository.adg;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import Dto.adg.BunryuDto;
import Dto.adg.FacilityDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class FacilityRepositoryImpl implements FacilityRepository {
	private final SqlSession sqlSession;

	@Override
	public List<FacilityDto> getAllFacility(int page, int size) {
		// 리턴용 데이터 설정
		List<FacilityDto> facilityDtos = null;
		
		// 파라미터 설정
		Map<String, Object> params = new HashMap<>();
		params.put("page", page);
		params.put("size", size);
		
		try {
			// SELECT : 시설물 데이터
			facilityDtos = sqlSession.selectList("Facility.getAllFacility", params);
			
			// System.out.println(facilityDtos);
		}
		catch (Exception e) {
			// TODO: handle exception
			System.out.println("시설물 가져오기 실패");
		}

		return facilityDtos;
	}

	@Override
	public List<BunryuDto> getAllFacilityType() {
		// 리턴용 데이터 설정
		List<BunryuDto> bunryuDtos = null;
		
		try {
			// SELECT : 시설물의 모든 종류
			bunryuDtos = sqlSession.selectList("Facility.getAllFacilityType");
			
			// System.out.println(bunryuDtos);
		}
		catch (Exception e) {
			// TODO: handle exception
			System.out.println("시설물 종류 가져오기 실패");
		}

		return bunryuDtos;
	}

	@Override
	public int registFacility(FacilityDto facilityDto) {
		int result = 0;//실패 기본 설정
		
		try {
			System.out.println(facilityDto);
			// INSERT : 시설물
			result = sqlSession.insert("Facility.insertFacility", facilityDto);
		}
		catch (Exception e) {
			// TODO: handle exception
			System.out.println("TT");
			System.out.println(e);
			return result;//실패
		}
		
		return result;
	}

}
