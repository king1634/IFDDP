나의 말:
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
<!-- 지도 관련 시작-->
<!-- <link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" crossorigin>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
	crossorigin></script>
<style>
.ap5-map {
	min-height: 520px;
	width: 100%;
	border-radius: 12px
}
</style> -->
<!-- 지도 관련 끝-->
</head>

<body>
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
		<!-- 	지도(테스트용)
			<section class="ap5-right-top" aria-label="결과 영역">
				<div id="ap5-map" class="ap5-map"></div>
			</section> -->

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
const JSP_CTX = '${pageContext.request.contextPath}';
document.addEventListener('DOMContentLoaded', function () {
  // ▼ 여기 추가/교체
  const vars = document.getElementById('ap5-vars');
  const CTX  = (vars?.dataset.ctx && vars.dataset.ctx.length>0) ? vars.dataset.ctx : JSP_CTX;
  const CSRF_HEADER = vars?.dataset.csrfHeader || '';
  const CSRF_TOKEN  = vars?.dataset.csrfToken || '';

  // ==== 사이드바 토글 ====
  const sb  = document.getElementById('sidebar');
  const btn = document.getElementById('sbToggle');
  if (sb && btn) {
    btn.addEventListener('click', function () {
      sb.classList.toggle('collapsed');
      document.body.classList.toggle('is-collapsed');
      btn.innerHTML = sb.classList.contains('collapsed')
        ? '<i class="bi bi-chevron-double-right"></i>'
        : '<i class="bi bi-chevron-double-left"></i>';
    });
  }

  // 접힘 상태에서 드롭다운 summary 클릭 → 기본 URL로 이동
  document.querySelectorAll('details.menu > summary').forEach(function (sum) {
    sum.addEventListener('click', function (e) {
      if (document.body.classList.contains('is-collapsed')) {
        e.preventDefault();
        e.stopPropagation();
        const url = sum.parentElement.dataset.href || sum.dataset.href;
        if (url) location.href = url;
      }
    });
  });

// ===== ★ 지도 초기화 =====
/* const mapEl = document.getElementById('ap5-map');
let map, dotLayer, canvasRenderer;       // ← dotLayer, canvasRenderer 선언

if (mapEl) {
  map = L.map('ap5-map', { zoomControl: true });
  map.setView([37.5665, 126.9780], 12);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19, attribution: '&copy; OpenStreetMap'
  }).addTo(map);

  canvasRenderer = L.canvas({ padding: 0.5 }); // ← 추가
  dotLayer = L.layerGroup().addTo(map);        // ← markerLayer 대신 dotLayer 사용
} */
  // 위험도 색상 (원하는 값으로 바꿔도 됨)
const RISK_COLOR = {
  '위험': '#ef4444',      // .ap5-dot--danger
  '경고': '#f59e0b',      // .ap5-dot--warn
  '정상': '#22c55e',      // .ap5-dot--ok  (기존 #10b981 → #22c55e)
  '데이터없음': '#cbd5e1', // .ap5-dot--none (기존 #94a3b8 → #cbd5e1)
  '': '#cbd5e1', null: '#cbd5e1', undefined: '#cbd5e1'
};

  // ===== 점만 찍기 =====
function renderDots(data) {
  if (!map || !dotLayer) return;

  dotLayer.clearLayers();
  const items = Array.isArray(data?.items) ? data.items : [];
  const latLngs = [];

  for (const it of items) {
    const lat = it.facilityGeomY;             // ← 변경
    const lng = it.facilityGeomX;             // ← 변경
    const risk = it.damageTypeKorean || '데이터없음'; // ← 변경
    if (lat == null || lng == null) continue;

    const c = RISK_COLOR[risk] ?? RISK_COLOR['데이터없음'];
    L.circleMarker([lat, lng], {
      renderer: canvasRenderer,
      radius: 6, fillColor: c, color: c, weight: 0, fillOpacity: 0.9
    }).addTo(dotLayer);

    latLngs.push([lat, lng]);
  }

  if (latLngs.length) map.fitBounds(latLngs, { padding: [20, 20] });
}


  // ===== AJAX (핵심: renderDots만 호출) =====
  const chips   = document.querySelector('.ap5-chips');
  const totalEl = document.getElementById('ap5Total');
  if (!chips || !totalEl) return;

  async function loadFacilities(type) {
    try {
      const url = (CTX || '') + '/agingPatternDots?facilityType=' + (type || 0);
      const headers = {};
      if (CSRF_HEADER && CSRF_TOKEN) headers[CSRF_HEADER] = CSRF_TOKEN;

      const res = await fetch(url, { method: 'GET', headers });
      if (!res.ok) throw new Error('HTTP ' + res.status);

      const data = await res.json();
      totalEl.textContent = (data && data.total != null ? data.total : 0);

      // ★ 리스트 렌더링 X → 점만
      renderDots(data);
    } catch (e) {
      console.error(e);
    }
  }

  chips.addEventListener('click', function (e) {
    const btn = e.target.closest('.ap5-chip');
    if (!btn) return;
    chips.querySelectorAll('.ap5-chip').forEach(b => b.classList.remove('ap5-chip--active'));
    btn.classList.add('ap5-chip--active');
    loadFacilities(btn.value || 0);
  });

  const active = chips.querySelector('.ap5-chip--active');
  loadFacilities(active ? active.value : 0);
});
</script>

</body>
</html>