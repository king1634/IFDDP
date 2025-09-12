<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>노후화 패턴</title>
<!-- 커스텀 스타일 공통 변수 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/theme.css">
<!-- 헤더/content css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerMain.css">
<!-- 노후화 패턴 폼 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agingPattern.css">
</head>

<body>
	사이드바 include: 반드시 BODY 안에
	<%@ include file="/WEB-INF/views/common/side.jsp"%>

	<!-- 상단 헤더 -->
	<header class="header">
		<h1>노후화 패턴 분석</h1>
	</header>

	<!-- 본문 시작(여기부터 입력) -->
	<div class="content">
		<div class="ap5-layout">
			<!-- 왼쪽 패널 -->
			<aside class="ap5-left">
				<!-- 지역 선택 -->
				<section class="ap5-card">
					<h2 class="ap5-h2">지역 선택</h2>
					<div class="ap5-grid-2">
						<label class="ap5-field"> <span class="ap5-label">시/도</span>
							<select class="ap5-input">
								<option>서울특별시</option>
						</select>
						</label> <label class="ap5-field"> <span class="ap5-label">시/군/구</span>
							<select class="ap5-input">
								<option>마포구</option>
						</select>
						</label>
					</div>
				</section>

				<!-- 사회기반시설 -->
				<section class="ap5-card">
					<h2 class="ap5-h2">사회기반시설</h2>
					<div class="ap5-chips" role="group" aria-label="시설 종류">
						<button type="button" class="ap5-chip ap5-chip--active">전체</button>
						<button type="button" class="ap5-chip" value="1">건축물</button>
						<button type="button" class="ap5-chip" value="2">도로</button>
						<button type="button" class="ap5-chip" value="3">도보</button>
						<button type="button" class="ap5-chip" value="4">교량</button>
						<button type="button" class="ap5-chip" value="5">터널</button>
						<button type="button" class="ap5-chip" value="6">옹벽</button>
						<button type="button" class="ap5-chip" value="7">하천</button>
						<button type="button" class="ap5-chip" value="8">상하수도</button>
						<button type="button" class="ap5-chip" value="9">절토사면</button>
					</div>
				</section>

				<!-- 총 개체 수 (버튼 없음) -->
				<section class="ap5-card">
					<div class="ap5-kpi">
						<span>총 개체 수</span> <strong id="ap5Total">0</strong>
					</div>
				</section>

				<!-- 범례 -->
				<section class="ap5-card">
					<h2 class="ap5-h2">손상위험도평가</h2>
					<ul class="ap5-legend">
						<li><span class="ap5-dot ap5-dot--danger"></span>위험</li>
						<li><span class="ap5-dot ap5-dot--warn"></span>경고</li>
						<li><span class="ap5-dot ap5-dot--ok"></span>보통</li>
						<li><span class="ap5-dot ap5-dot--none"></span>데이터없음</li>
					</ul>
				</section>
			</aside>

			<!-- 오른쪽 결과 영역 -->
			<section class="ap5-right-top" aria-label="결과 영역">
				<div class="ap5-canvas">여기에 지도/차트가 표시됩니다</div>
			</section>

			<section class="ap5-right-bottom ap5-card">아래 전체 폭
				컨텐츠(표/리스트/추가 차트 등)</section>
		</div>
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