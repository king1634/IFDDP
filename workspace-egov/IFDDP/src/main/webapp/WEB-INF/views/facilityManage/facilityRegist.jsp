<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>시설물 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/theme.css">
<!-- 커스텀 스타일 공통 변수 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerMain.css">
<!-- 헤더/content css -->
<!-- adg css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/facilityRegistStyle.css">
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
//1. API에서 시설물 종류 데이터 가져오기
$(document).ready(function() {
	$.ajax({
		// 서울시의 모든 구 데이터 가져오기(25개)
		// data.seoul.go.kr 안도건 인증키 : 557152464f64676133394772706c43
		// http://openapi.seoul.go.kr:8088/557152464f64676133394772706c43/xml/SearchMeasuringSTNOfAirQualityService/1/25
        url: 'api/seoul/sigungu', // API 경로
        type: 'GET',
        dataType: 'json',
        success: function(data) {
        	let options = "";
            // 데이터가 바로 배열 형태로 오는 경우
            $.each(data, function(index, district) {
                // console.log(index, district);
                options += "<option value=" + district.code + ">" + district.name + "</option>";
            });
            
            // console.log(options);
            
            // select 요소에 옵션 추가
            $("#region-sigungu").html(options);
        },
        error: function(error) {
            console.error('시군구 데이터 불러오기 실패했습니다:', error);
        }
	})
	
    $.ajax({
        url: 'allFacilityType', // API 경로
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            // 2. select 옵션 생성하기
            let options = '<option value="999">시설물 종류 선택</option>';
            
            // 3. 데이터 순회하면서 옵션 추가
            $.each(data, function(index, facilityType) {
            	// console.log(facilityType.contents);
                options += "<option value=" + facilityType.mcd + ">" + facilityType.contents + "</option>";
            });
            
            // 4. select 요소에 옵션 추가
            $('#facilityType').html(options);
        },
        error: function(error) {
            console.error('시설물 종류 데이터를 불러오는 데 실패했습니다:', error);
        }
    });
});
</script>
<body>
	<%-- 사이드바 include: 반드시 BODY 안에 --%>
	<%@ include file="/WEB-INF/views/common/side.jsp"%>

	<!-- 상단 헤더 -->
	<header class="header">
		<h1>시설물 관리</h1>
	</header>

	<!-- 본문 시작(여기부터 입력) -->
	<div class="content">
		<div class="main-title">시설물 등록</div>
		<hr class="main-title-line">
		
		<!-- 시설물 등록 정보 입력 -->
		<form id="registFacility" onsubmit="return validateForm()">
			<div class="form-groups">
				<div class="form-row-group">
					<div class="form-group">
		                <label for="facilityName">시설물 명</label>
		                <p/>
		                <input type="text" id="facilityName" class="form-control" placeholder="시설물 명" required="required">
		            </div>
				</div>
				<div class="form-row-group">
					<div class="form-group half-width">
		                <label for="facilityRegion">시설물 주소</label>
		                <p/>
		                <div style="display: flex; gap: 10px;">
			                <select id="region-sido" style="width: 50%">
			                	<option>서울시</option>
			                </select>
			                <select id="region-sigungu" style="width: 50%">
			                </select>
		                </div>
		            </div>
					<div class="form-group half-width">
		                <label for="facilityAddress">시설물 상세 주소</label>
		                <p/>
		                <input type="text" id="facilityAddress" class="form-control" placeholder="시설물 상세 주소">
		            </div>
				</div>
				<div class="form-row-group">
					<div class="form-group half-width">
		                <label for="facilityType">시설물 종류</label>
		                <p/>
		                <select id="facilityType"></select>
		            </div>
					<div class="form-group half-width">
		                <label for="facilityScale">시설물 규모</label>
		                <p/>
		                <select>
		                	<option value="1">1종</option>
		                	<option value="2">2종</option>
		                	<option value="3">3종</option>
		                </select>
		            </div>
				</div>
				<div class="form-row-group">
					<div class="form-group">
		                <label for="facilityGeom">시설물 위치좌표</label>
		                <p/>
		                <div style="display: flex; gap: 10px;">
			                <label style="display: flex; align-items: center; height: 30px; margin: auto;">X:</label>
			                <input type="text" id="facilityGeomX" class="form-control" placeholder="시설물 위치좌표 X" required="required">
			                <label style="display: flex; align-items: center; height: 30px; margin: auto;">Y:</label>
			                <input type="text" id="facilityGeomY" class="form-control" placeholder="시설물 위치좌표 Y" required="required">
		                </div>
		            </div>
				</div>
				<div class="form-row-group">
					<div class="form-group">
		                <label for="facilityYearBuilt">준공년도</label>
		                <p/>
		                <input type="date" id="facilityYearBuilt" class="form-control" placeholder="준공년도">
		                <script>
							// 오늘 날짜 가져오기
							const today = new Date();
							
							// YYYY-MM-DD 형식으로 변환 (input type="date"가 요구하는 형식)
							const year = today.getFullYear();
							const month = String(today.getMonth() + 1).padStart(2, '0');
							const day = String(today.getDate()).padStart(2, '0');
							const formattedDate = year + "-" + month + "-" + day;

							// input 요소에 오늘 날짜 설정
							document.getElementById('facilityYearBuilt').value = formattedDate;
						</script>
		            </div>
				</div>
				<div style="display: flex; justify-content: flex-end; gap: 10px;">
					<button type="submit" class="regist-btn">등록</button>
					<button class="cancel-btn">취소</button>
				</div>
			</div>
		</form>
	</div>
	<!-- 본문 끝(여기까지 입력)-->

	<!-- 접힘/펼침 및 드롭다운-접힘 이동 로직 -->
	<script>
	document.addEventListener('DOMContentLoaded', () => {
		const sb  = document.getElementById('sidebar');
		const btn = document.getElementById('sbToggle');
		if (!sb || !btn) return;
		
		btn.addEventListener('click', () => {
			sb.classList.toggle('collapsed');               // 사이드바 폭 토글
			document.body.classList.toggle('is-collapsed'); // 헤더/본문 위치 동기화
			
			btn.innerHTML = sb.classList.contains('collapsed')
			  ? '<i class="bi bi-chevron-double-right"></i>'
			  : '<i class="bi bi-chevron-double-left"></i>';
		});
		
		// 접힘 상태에서 드롭다운 summary 클릭 → 기본 URL로 이동
		document.querySelectorAll('details.menu > summary').forEach(sum => {
			sum.addEventListener('click', (e) => {
				if (document.body.classList.contains('is-collapsed')) {
					e.preventDefault();
					e.stopPropagation();
					const url = sum.parentElement.dataset.href || sum.dataset.href;
					if (url) location.href = url;
				}
			});
		});
	});
	</script>
</body>
</html>