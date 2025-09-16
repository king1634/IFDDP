package Util;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.io.WKBReader;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class GISPointConverter {
	private final SqlSession sqlSession;

	public static Point getLatLonFromGeom(String geom){
		Point point = null;
		try {
			// 16진수 문자열을 바이트 배열로 변환
	        byte[] wkbBytes = hexStringToByteArray(geom);

	        // WKBReader를 사용하여 Geometry 객체로 변환
	        WKBReader wkbReader = new WKBReader();
	        Geometry geometry = wkbReader.read(wkbBytes);

	        // Point 객체로 캐스팅
	        if (geometry instanceof Point) {
	            point = (Point) geometry;
	            
//	            double longitude = point.getX();
//	            double latitude = point.getY();
//	            System.out.println("위도(Latitude): " + latitude);
//	            System.out.println("경도(Longitude): " + longitude);
	        }
		} catch (Exception e) {
			System.out.println("좌표 변환 불가능 : " + geom);
			System.out.println(e);
            // e.printStackTrace();
        }
        
		return point;
	}
	
    // 16진수 문자열을 바이트 배열로 변환하는 유틸리티 메서드
    private static byte[] hexStringToByteArray(String s) {
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                    + Character.digit(s.charAt(i + 1), 16));
        }
        return data;
    }
}
