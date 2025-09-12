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
<style>
/* 레이아웃: 좌(패널) 우(캔버스) */
.ap5-layout {
	position: relative;
	display: grid;
	grid-template-columns: 360px minmax(0, 1fr); /* 좌, 우 */
	grid-template-rows: 3fr 1fr; /* 위, 아래 */
	grid-template-areas: "left rightTop" "left rightBottom";
	column-gap: 24px;
	row-gap: 24px;
	align-items: stretch;
	min-height: calc(100vh - var(--hdh)- 48px);
}

/* 세로 구분선(전체 높이) — 현재 DOM에 요소를 추가하지 않아 표시되지 않습니다 */
.ap5-vsep {
	grid-column: 2;
	grid-row: 1/-1; /* 모든 행을 가로지름 */
	align-self: stretch; /* 세로로 꽉 채움 */
	width: 1px;
	background: #e5e7eb;
	border-radius: 1px;
}

.ap5-rightCol {
	display: grid;
	grid-template-rows: 2fr 1fr; /* 위:아래 = 2:1 (예: 66:33) */
	row-gap: 24px;
}

.ap5-left {
	grid-area: left;
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.ap5-right-top {
	grid-area: rightTop;
}

.ap5-right-bottom {
	grid-area: rightBottom;
}

/* 콘텐츠가 행 높이에 맞도록 */
.ap5-right-top, .ap5-right-bottom {
	min-height: 0;
}

.ap5-right-top>.ap5-canvas {
	height: 100%;
	min-height: 0;
}

.ap5-canvas {
	min-height: 520px;
	background: #f7f9fb;
	border: 1px dashed #dcdfe6;
	border-radius: 12px;
	display: grid;
	place-items: center;
	color: #6b7280;
}

/* 공통 카드/폼/칩 */
.ap5-card {
	background: #fff;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	padding: 16px;
	box-shadow: 0 1px 2px rgba(16, 24, 40, .04);
}

.ap5-h2 {
	margin: 0 0 12px;
	font-size: 15px;
	font-weight: 800;
	color: #0f172a;
}

.ap5-grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 12px;
}

/* 좁아질 때: 1열 스택 + 지도/컨텐츠 크게 확보 */
@media ( max-width : 1080px) {
	.ap5-layout {
		grid-template-columns: 1fr;
		/* 좌측 패널 → 지도 → 하단 컨텐츠 순서, 세로 공간 넉넉히 확보 */
		grid-template-rows: auto minmax(70svh, auto) minmax(55svh, auto);
		grid-template-areas: "left" "rightTop" "rightBottom";
		column-gap: 0;
		row-gap: 16px;
	}
	.ap5-vsep {
		display: none;
	}
	.ap5-grid-2 {
		grid-template-columns: 1fr;
	}

	/* 지도(상단) 크게 */
	.ap5-right-top {
		min-height: 70svh;
	}
	.ap5-right-top>.ap5-canvas {
		min-height: 0; /* 부모 min-height 간섭 방지 */
		height: 70vh; /* 구형 브라우저 폴백 */
		height: 70svh; /* 주소창 포함 최소 뷰포트 기준 */
	}

	/* 하단 컨텐츠도 넉넉히 */
	.ap5-right-bottom {
		min-height: 55svh;
	}
}

.ap5-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.ap5-label {
	font-size: 12px;
	color: #475569;
	font-weight: 600;
}

.ap5-input {
	border: 1px solid #d1d5db;
	background: #fff;
	border-radius: 10px;
	padding: 10px 12px;
	height: 40px;
	font-size: 14px;
	outline: none;
	transition: border-color .15s, box-shadow .15s;
}

.ap5-layout, .ap5-left, .ap5-right-top, .ap5-right-bottom {
	min-width: 0;
} /* 넘침 방지 */
.ap5-input:focus {
	border-color: #5a97c8;
	box-shadow: 0 0 0 3px rgba(90, 151, 200, .2);
}

.ap5-chips {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.ap5-chip {
	border: 1px solid #d1d5db;
	background: #fff;
	border-radius: 999px;
	padding: 8px 12px;
	font-weight: 600;
	font-size: 13px;
	cursor: pointer;
	transition: all .15s;
}

.ap5-chip:hover {
	background: #f4f7fb;
}

.ap5-chip--active {
	background: #e7f0fa;
	border-color: #5a97c8;
	color: #185a93;
}

.ap5-kpi {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.ap5-kpi strong {
	font-size: 20px;
	color: #0f172a;
}

.ap5-legend {
	list-style: none;
	padding: 0;
	margin: 0;
	display: grid;
	gap: 8px;
}

.ap5-dot {
	width: 12px;
	height: 12px;
	border-radius: 50%;
	display: inline-block;
	margin-right: 8px;
	border: 2px solid #334155;
}

.ap5-dot--danger {
	background: #ef4444;
}

.ap5-dot--warn {
	background: #f59e0b;
}

.ap5-dot--ok {
	background: #22c55e;
}

.ap5-dot--none {
	background: #cbd5e1;
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
								<option>강남구</option>
								<option>송파구</option>
						</select>
						</label>
					</div>
				</section>

				<!-- 사회기반시설 -->
				<section class="ap5-card">
					<h2 class="ap5-h2">사회기반시설</h2>
					<div class="ap5-chips" role="group" aria-label="시설 종류">
						<button type="button" class="ap5-chip ap5-chip--active">전체</button>
						<button type="button" class="ap5-chip">건축물</button>
						<button type="button" class="ap5-chip">교량</button>
						<button type="button" class="ap5-chip">터널</button>
						<button type="button" class="ap5-chip">상하수도</button>
						<button type="button" class="ap5-chip">옹벽</button>
						<button type="button" class="ap5-chip">절토사면</button>
						<button type="button" class="ap5-chip">하천</button>
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