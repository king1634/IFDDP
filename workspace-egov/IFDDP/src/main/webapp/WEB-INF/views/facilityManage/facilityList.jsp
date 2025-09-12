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
	href="${pageContext.request.contextPath}/resources/css/facilityListStyle.css">
</head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 전역 변수 설정
    let currentPage = 1;
    const itemsPerPage = 10;
    let loading = false;
    let allItemsLoaded = false;
    
    // 페이지 로드 시 초기 데이터 세팅
    $(document).ready(function() {
        // 초기 데이터는 이미 서버에서 렌더링됨
        setupInfiniteScroll();
    });
    
    // 무한 스크롤 설정
    function setupInfiniteScroll() {
        // Intersection Observer 생성
        const options = {
            root: null,
            rootMargin: '0px',
            threshold: 0.1
        };
        
        const observer = new IntersectionObserver(handleIntersect, options);
        
        // 테이블 마지막 행을 관찰 대상으로 설정
        const target = document.querySelector('.board-table tbody tr:last-child');
        if (target) {
            observer.observe(target);
        }
    }
    
    // 관찰 대상이 화면에 보일 때 실행되는 함수
    function handleIntersect(entries, observer) {
        entries.forEach(entry => {
            if (entry.isIntersecting && !loading && !allItemsLoaded) {
                loadMoreItems();
            }
        });
    }
    
    // 추가 데이터 로드 함수
    function loadMoreItems() {
        loading = true;
        
        // 로딩 표시 추가
        $('.board-table tbody').append('<tr class="loading-row"><td colspan="5" style="text-align:center;">로딩 중...</td></tr>');
        
        // 다음 페이지 데이터 요청
        currentPage++;
        
        $.ajax({
            url: '${pageContext.request.contextPath}/facility',
            type: 'GET',
            data: {
                page: currentPage,
                size: itemsPerPage
            },
            success: function(response) {
                // 로딩 표시 제거
                $('.loading-row').remove();
                
                // 데이터가 없으면 모든 항목 로드 완료
                if (response.length === 0) {
                    allItemsLoaded = true;
                    $('.board-table tbody').append('<tr class="end-row"><td colspan="5" style="text-align:center;">모든 시설물을 불러왔어요! 🎉</td></tr>');
                    return;
                }
                
                // 받은 데이터를 테이블에 추가
                let html = '';
                response.forEach(facility => {
                	// 타임스탬프를 날짜 형식으로 변환
                    let yearBuiltFormatted = facility.yearBuilt;
                    // 숫자인 경우(타임스탬프)에만 변환 처리
                    if (!isNaN(facility.yearBuilt)) {
                        const date = new Date(parseInt(facility.yearBuilt));
                        yearBuiltFormatted = date.getFullYear() + '-' + 
                                            (date.getMonth() + 1).toString().padStart(2, '0') + '-' + 
                                            date.getDate().toString().padStart(2, '0');
                    }
                    
                	html += '<tr>' +
                    '<td>' + (facility.facilityId || '') + '</td>' +
                    '<td>' + (facility.facilityName || '') + '</td>' +
                    '<td>' + (facility.region || '') + '</td>' +
                    '<td>' + (facility.address || '') + '</td>' +
                    '<td>' + yearBuiltFormatted + '</td>' +
                    '</tr>';
                    // console.log(facility.facilityName);
                });

                
                // console.log(html);
                
                // 새 데이터를 테이블에 추가
                $('.board-table tbody').append(html);
                
                // 새로 추가된 마지막 행에 observer 다시 설정
                setupInfiniteScroll();
                
                loading = false;
            },
            error: function(error) {
                $('.loading-row').remove();
                $('.board-table tbody').append('<tr class="error-row"><td colspan="5" style="text-align:center;">데이터를 불러오는 중 오류가 발생했어요 😥</td></tr>');
                console.error('데이터 로드 실패:', error);
                loading = false;
            }
        });
    }
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
		<div class="main-title">시설물 목록</div>
		<hr class="main-title-line">
		
		<div class="control-div">
			<!-- 등록 -->
			<button class="regist-btn" onclick="location.href='facilityRegist.do'">등록버튼</button>
			<button class="regist-btn">Excel 다운로드</button>
			<button class="regist-btn">Excel 업로드</button>
			<!-- 검색 -->
			<!-- <label>검색 항목</label> -->
		</div>
		
		<table class="board-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>시설물 이름</th>
                    <th>지역</th>
                    <th>주소</th>
                    <th>준공년도</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty facilityList}">
                        <c:forEach var="facility" items="${facilityList}" varStatus="status">
                            <tr>
                                <td>${facility.facilityId}</td>
                                <td>${facility.facilityName}</td>
                                <td>${facility.region}</td>
                                <td>${facility.address}</td>
                                <td><fmt:formatDate value="${facility.yearBuilt}" pattern="yyyy-MM-dd"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise> <!-- facilityList가 비어있다면 -->
                        <tr>
                            <td colspan="5" class="no-data">🥲 표시할 시설물 정보가 없어요.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
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