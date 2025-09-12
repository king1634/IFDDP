<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>노후화 패턴</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/theme.css">
<!-- 커스텀 스타일 공통 변수 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerMain.css">
<!-- 헤더/content css -->
</head>
<body>
	<%-- 사이드바 include: 반드시 BODY 안에 --%>
	<%@ include file="/WEB-INF/views/common/side.jsp"%>

	<!-- 상단 헤더 -->
	<header class="header">
		<h1>노후화 패턴 분석</h1>
	</header>

	<!-- 본문 시작(여기부터 입력) -->
	<div class="content">본문 영역</div>
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

      // 접힘 상태에서 드롭다운 	summary 클릭 → 기본 URL로 이동
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
<%-- <style>
/* ------- Layout ------- */
.ap4-layout {
	display: grid;
	grid-template-columns: 360px minmax(0, 1fr);
	gap: 20px;
}

@media ( max-width : 1080px) {
	.ap4-layout {
		grid-template-columns: 1fr;
	}
}

.ap4-panel {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.ap4-canvas {
	min-height: 60vh;
}

.ap4-placeholder {
	height: 520px;
	border: 1px dashed #d6d9e0;
	border-radius: 12px;
	display: grid;
	place-items: center;
	color: #6b7280;
	background: #fafbfc;
}

/* ------- Card ------- */
.ap4-card {
	background: #fff;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	padding: 16px;
	box-shadow: 0 1px 2px rgba(16, 24, 40, .04);
}

/* ------- Headings ------- */
.ap4-h2 {
	margin: 0 0 12px;
	font-size: 15px;
	font-weight: 800;
	color: #0f172a;
}

/* ------- Form ------- */
.ap4-grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 12px;
}

@media ( max-width : 480px) {
	.ap4-grid-2 {
		grid-template-columns: 1fr;
	}
}

.ap4-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.ap4-label {
	font-size: 12px;
	color: #475569;
	font-weight: 600;
}

.ap4-input {
	border: 1px solid #d1d5db;
	background: #fff;
	border-radius: 10px;
	padding: 10px 12px;
	height: 40px;
	font-size: 14px;
	outline: none;
	transition: border-color .15s, box-shadow .15s;
}

.ap4-input:focus {
	border-color: #5a97c8;
	box-shadow: 0 0 0 3px rgba(90, 151, 200, .2);
}

/* ------- Chips ------- */
.ap4-chips {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.ap4-chip {
	border: 1px solid #d1d5db;
	background: #fff;
	border-radius: 999px;
	padding: 8px 12px;
	font-weight: 600;
	font-size: 13px;
	cursor: pointer;
	transition: all .15s;
}

.ap4-chip:hover {
	background: #f4f7fb;
}

.ap4-chip--active {
	background: #e7f0fa;
	border-color: #5a97c8;
	color: #185a93;
}

/* ------- KPI + Actions ------- */
.ap4-kpi {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding-bottom: 12px;
	border-bottom: 1px solid #eef0f4;
	margin-bottom: 12px;
}

.ap4-kpi strong {
	font-size: 20px;
	color: #0f172a;
}

.ap4-actions {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
}

.ap4-btn {
	height: 38px;
	padding: 0 14px;
	font-weight: 700;
	border-radius: 10px;
	cursor: pointer;
	border: 1px solid transparent;
	transition: background .15s, border-color .15s, color .15s;
}

.ap4-btn--ghost {
	background: #fff;
	border-color: #d1d5db;
}

.ap4-btn--ghost:hover {
	background: #f7fafc;
}

.ap4-btn--primary {
	background: #3b82f6;
	color: #fff;
}

.ap4-btn--primary:hover {
	background: #2563eb;
}

/* ------- Legend ------- */
.ap4-legend summary {
	list-style: none;
	cursor: pointer;
}

.ap4-legend summary::-webkit-details-marker {
	display: none;
}

.ap4-legend-list {
	list-style: none;
	margin: 12px 0 0;
	padding: 0;
	display: grid;
	gap: 8px;
}

.ap4-dot {
	width: 12px;
	height: 12px;
	border-radius: 50%;
	display: inline-block;
	margin-right: 8px;
	border: 2px solid #334155;
}

.ap4-dot--danger {
	background: #ef4444;
}

.ap4-dot--warn {
	background: #f59e0b;
}

.ap4-dot--ok {
	background: #22c55e;
}

.ap4-dot--none {
	background: #cbd5e1;
}

/* 접근성 */
.ap4-chip:focus-visible, .ap4-btn:focus-visible, .ap4-legend summary:focus-visible
	{
	outline: 3px solid rgba(90, 151, 200, .35);
	outline-offset: 3px;
}
</style>

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
		<div class="ap4-layout">
			<!-- 왼쪽 패널 -->
			<aside class="ap4-panel" aria-label="필터">
				<section class="ap4-card">
					<h2 class="ap4-h2">지역 선택</h2>
					<div class="ap4-grid-2">
						<label class="ap4-field"> <span class="ap4-label">시/도</span>
							<select class="ap4-input">
								<option>서울특별시</option>
								<option>부산광역시</option>
								<option>대구광역시</option>
						</select>
						</label> <label class="ap4-field"> <span class="ap4-label">시/군/구</span>
							<select class="ap4-input">
								<option>마포구</option>
								<option>강남구</option>
								<option>송파구</option>
						</select>
						</label>
					</div>
				</section>

				<section class="ap4-card">
					<h2 class="ap4-h2">사회기반시설</h2>
					<div class="ap4-chips" role="group" aria-label="시설 종류">
						<button type="button" class="ap4-chip ap4-chip--active">전체</button>
						<button type="button" class="ap4-chip">건축물</button>
						<button type="button" class="ap4-chip">교량</button>
						<button type="button" class="ap4-chip">터널</button>
						<button type="button" class="ap4-chip">상하수도</button>
						<button type="button" class="ap4-chip">옹벽</button>
						<button type="button" class="ap4-chip">절토사면</button>
						<button type="button" class="ap4-chip">하천</button>
					</div>
				</section>

				<section class="ap4-card">
					<div class="ap4-kpi">
						<span>총 개체 수</span> <strong id="ap4Total">0</strong>
					</div>
					<div class="ap4-actions">
						<button type="button" class="ap4-btn ap4-btn--ghost" id="ap4Reset">초기화</button>
						<button type="button" class="ap4-btn ap4-btn--primary">분석
							결과</button>
					</div>
				</section>

				<section class="ap4-card">
					<details class="ap4-legend" open>
						<summary class="ap4-h2">손상위험도평가</summary>
						<ul class="ap4-legend-list">
							<li><span class="ap4-dot ap4-dot--danger"></span>위험</li>
							<li><span class="ap4-dot ap4-dot--warn"></span>경고</li>
							<li><span class="ap4-dot ap4-dot--ok"></span>보통</li>
							<li><span class="ap4-dot ap4-dot--none"></span>데이터없음</li>
						</ul>
					</details>
				</section>
			</aside>

			<!-- 우측 작업영역(지도/차트 등) -->
			<section class="ap4-canvas" aria-label="결과 영역">
				<div class="ap4-placeholder">여기에 지도/차트가 표시됩니다</div>
			</section>
		</div>

	</div> --%>
