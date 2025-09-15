package Service.adg;

import java.util.List;

import org.geotools.geometry.DirectPosition2D;
import org.geotools.referencing.CRS;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.opengis.referencing.operation.TransformException;
import org.springframework.stereotype.Service;

import Dto.adg.BunryuDto;
import Dto.adg.FacilityDto;
import Repository.adg.DamageRepository;
import Repository.adg.FacilityRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FacilityServiceImpl implements FacilityService {
	private final FacilityRepository facilityRepository;
	private final DamageRepository damageRepository;

	@Override
	public List<FacilityDto> getAllFacilityAllInfo() {
		//시설물의 모든 정보를 가져온다.
		return facilityRepository.getAllFacilityAllInfo();
	}
	
	@Override
	public List<FacilityDto> getAllFacility(int page, int size) {
		
		return facilityRepository.getAllFacility(page, size);
	}

	@Override
	public List<BunryuDto> getAllFacilityType() {
		
		return facilityRepository.getAllFacilityType();
	}

	@Override
	public List<BunryuDto> getDamageTypeOfFacility(int facilityType) {
		
		return facilityRepository.getDamageTypeOfFacility(facilityType);
	}
	
	@Override
	public int registFacility(FacilityDto facilityDto) {
		// 정상적인 데이터인지 확인
		
		// LatLon -> geom(EPSG:5186) 가공
        try {
            // WGS84 좌표계 (EPSG:4326)
            CoordinateReferenceSystem sourceCRS = CRS.decode("EPSG:4326");
            // 목표 좌표계 (EPSG:5186, 중부원점)
            CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:5186");
            
            // 변환기 생성
            MathTransform transform = CRS.findMathTransform(sourceCRS, targetCRS);
            
            // 위경도 좌표 (경도, 위도 순서)
            double lat = facilityDto.getFacilityGeomX();
            double lon = facilityDto.getFacilityGeomY();
            
            // 변환 실행
            DirectPosition2D srcPoint = new DirectPosition2D(lon, lat);
            DirectPosition2D dstPoint = new DirectPosition2D();
            transform.transform(srcPoint, dstPoint);
            
            // 변환된 좌표 출력
//            System.out.println("변환 결과: X=" + dstPoint.x + ", Y=" + dstPoint.y);
//            System.out.println(dstPoint);//DirectPosition2D[6367142.568326866, 4377658.4916852]

            // INSERT 형태 : ST_SetSRID(ST_MakePoint(126.9002, 37.5779), 5186), 
            facilityDto.setGeom("ST_SetSRID(ST_MakePoint("+ lat + ", " + lon + "), 5186)"); 
        } catch (FactoryException | TransformException e) {
            e.printStackTrace();
        }
        
		// region 가공
        facilityDto.setRegion(facilityDto.getRegionSido() + " " + facilityDto.getRegionSigungu());

		// 시설물 데이터 넣기
		int resultFacility = facilityRepository.registFacility(facilityDto);

		// 손상 데이터 넣기
		List<Integer> resultDamage = damageRepository.registDamage(resultFacility, facilityDto.getDamageList());
		
		// 손상 이미지 넣기
		
		return resultFacility;
	}

	
}
