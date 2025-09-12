	package Controller;
	
	
	import java.io.FileInputStream;
	import java.io.IOException;
	import java.io.InputStream;
	
	import javax.servlet.http.HttpServletResponse;
	
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.util.StreamUtils;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
	
	@Controller
	@RequestMapping("/map")
	public class MapController {
	
		    @GetMapping("/view.do")
		    public String mapView(Model model) {
		    	
				/*
				 * // SHP → GeoServer에서 GeoJSON으로 접근 가능하다고 가정 String geoJsonUrl =
				 * "http://localhost:8081/geoserver/mapo/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=mapo:n3a_a0070000&outputFormat=application/json&srsName=EPSG:4326";
				 * 
				 * model.addAttribute("geoJsonUrl", geoJsonUrl);
				 */
		    	
		    	// webapp/resources/data/mapoDong.geojson를 읽을 수 있는 URL
				/*
				 * String geoJsonUrl = "/data/mapoDong.geojson"; // ResourceHandler 설정 필요
				 * model.addAttribute("geoJsonUrl", geoJsonUrl);
				 */
		    	System.out.println("--- view.do   End  ----");
		    	
		        return "map"; // map.jsp
		    }
		    
		    @GetMapping("/map/data/mapoDong.geojson")
		    public void getGeoJson(HttpServletResponse response) throws IOException {
		        InputStream is = new FileInputStream("src/main/webapp/resources/data/mapoDong.geojson");
		        response.setContentType("application/json");
		        StreamUtils.copy(is, response.getOutputStream());
		    }


		}
