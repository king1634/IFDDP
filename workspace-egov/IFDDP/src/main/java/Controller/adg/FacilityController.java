package Controller.adg;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import Dto.adg.BunryuDto;
import Dto.adg.FacilityDto;
import Service.adg.FacilityService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class FacilityController {
	private final FacilityService facilityService;
	
	@GetMapping("/facilityList.do")
	public String showFacilityList(Model model) {
		// 기본 10개의 시설물 데이터 가져오기
		List<FacilityDto> facilityDtos = facilityService.getAllFacility(0, 10);

		model.addAttribute("facilityList", facilityDtos);

		return "facilityManage/facilityList";
	}
	
	@GetMapping(value = "/facility", produces = "application/json")
    @ResponseBody
	public List<FacilityDto> getFacility(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        // 페이지는 1부터 시작하지만, 실제 계산은 0부터 시작해야 함
        int offset = (page - 1) * size;
        
        // 요청한 시설물 데이터 가져오기
		List<FacilityDto> facilityDtos = facilityService.getAllFacility(offset, size);
		
		return facilityDtos;
	}

	@GetMapping("/facilityRegist.do")
	public String showFacilityRegist(Model model) {
		// 등록 페이지로 이동
		return "facilityManage/facilityRegist";
	}
	@PostMapping("/facilityRegist")
	public String postfacilityRegist(FacilityDto facilityDto, RedirectAttributes redirectAttributes) {
		// 입력 데이터 확인
		//System.out.println(facilityDto);
		System.out.println(facilityDto.getDamageList());
		
		// 시설물 등록
		int result = facilityService.registFacility(facilityDto);

	    if (result > 0) {
	        // 등록 성공 시
	        redirectAttributes.addFlashAttribute("message", "시설물이 성공적으로 등록되었어요!");
	        return "redirect:/facilityList.do"; // 목록 페이지로 리다이렉트
	    } else {
	        // 등록 실패 시
	        redirectAttributes.addFlashAttribute("errorMessage", "시설물 등록에 실패했어요. 다시 시도해 주세요.");
	        
	        // 다시 등록 폼 페이지로 리다이렉트 (이 경우 현재 폼 페이지를 다시 띄워주는 URL로)
	        return "redirect:/facilityRegist.do"; 
	    }
	}
	
	
	@GetMapping(value = "/allFacilityType", produces = "application/json")
    @ResponseBody
	public List<BunryuDto> getFacilityType() {
        // 요청한 시설물 데이터 가져오기
		List<BunryuDto> bunryuDtos = facilityService.getAllFacilityType();
		
		return bunryuDtos;
	}
	@GetMapping(value = "/allDamageTypeOfFacility/{facilityType}", produces = "application/json")
    @ResponseBody
	public List<BunryuDto> getDamageTypeOfFacility(@PathVariable int facilityType) {
        // 요청한 시설물 데이터 가져오기
		List<BunryuDto> bunryuDtos = facilityService.getDamageTypeOfFacility(facilityType);
		
		return bunryuDtos;
	}

	@GetMapping(value = "/api/seoul/sigungu", produces = "application/json")
    @ResponseBody
	public List<Map<String, String>> getApiSeoulSigungu() {
		// 서울시의 모든 구 데이터 가져오기(25개)
		// data.seoul.go.kr 안도건 인증키 : 557152464f64676133394772706c43
		// http://openapi.seoul.go.kr:8088/557152464f64676133394772706c43/xml/SearchMeasuringSTNOfAirQualityService/1/25
		RestTemplate restTemplate = new RestTemplate();
        String apiUrl = "http://openapi.seoul.go.kr:8088/557152464f64676133394772706c43/xml/SearchMeasuringSTNOfAirQualityService/1/25";
        
        // API 호출
        ResponseEntity<String> response = restTemplate.getForEntity(apiUrl, String.class);

		// System.out.println(response);
		
		// XML 데이터 추출
		String xmlData = response.getBody();
		
		List<Map<String, String>> districts = new ArrayList<>();
	    
		// XML 데이터를 JSP에서 쓸 수 있도록 변환
	    try {
	        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	        DocumentBuilder builder = factory.newDocumentBuilder();
	        Document document = builder.parse(new InputSource(new StringReader(xmlData)));
	        
	        NodeList rows = document.getElementsByTagName("row");
	        for (int i = 0; i < rows.getLength(); i++) {
	            Node row = rows.item(i);
	            if (row.getNodeType() == Node.ELEMENT_NODE) {
	                Element element = (Element) row;
	                String code = element.getElementsByTagName("MSRADM").item(0).getTextContent();
	                String name = element.getElementsByTagName("MSRSTE_NM").item(0).getTextContent();
	                
	                Map<String, String> district = new HashMap<>();
	                district.put("code", code);
	                district.put("name", name);
	                districts.add(district);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return districts;
		
//        // 결과 반환 (헤더와 상태코드도 그대로 전달)
//        return new ResponseEntity<>(response.getBody(), response.getHeaders(), response.getStatusCode());
	}
	
	@GetMapping("facilityDownload")
	@ResponseBody
	public Object inventoryExcelDownload() {
		List<FacilityDto> facilityDtos = facilityService.getAllFacilityAllInfo();
		
		System.out.println(facilityDtos);
		
	    List<Map<String, Object>> excelData = facilityDtos.stream()
	        .map(datas -> {
	            Map<String, Object> row = new LinkedHashMap<>(); // 순서 유지를 위해 LinkedHashMap 사용
	            row.put("시설물 식별자", datas.getFacilityId());
	            row.put("시설물 명", datas.getFacilityName());
	            row.put("시설물 종류", datas.getFacilityTypeKorean());
	            row.put("시설물 규모", datas.getFacilityScaleKorean());
	            row.put("시설물 위치 좌표", datas.getGeom()); // 변환필요 -> lat,lon
	            row.put("시설물 지역", datas.getRegion());
	            row.put("시설물 상세 주소", datas.getAddress());
	            row.put("시설물 준공년도", datas.getYearBuilt()); // 변환필요
	            
//	            // 추가 필요 필드
//	            좌표LAT
//	            좌표LON
//	            선좌표
//	            면좌표
	            
//	            손상유형
//	            위험도
//	            점검자
//	            손상설명
//	            발생일
	            
	            return row;
	        })
	        .collect(Collectors.toList());
		
		return excelData;
	}
	
}
