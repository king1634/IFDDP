<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/sidebar.css">

<aside class="sidebar" id="sidebar" role="navigation" aria-label="사이드바">
	<div class="brand">
		<span class="logo">IF</span> <span class="title">IFDDP</span>
		<button type="button" class="toggle" id="sbToggle" title="축소/확장">
			<i class="bi bi-chevron-double-left"></i>
		</button>
	</div>

	<ul class="nav">
		<li><a href="/IFDDP/agingPattern.do"> <i
				class="bi bi-grid-1x2"></i><span class="label">노후화 패턴 분석</span>
		</a></li>
		<li><a href="#"> <i class="bi bi-journal-richtext"></i><span
				class="label">손상진단 시뮬레이션</span>
		</a></li>
			<li><a href="${pageContext.request.contextPath}/facilityList.do"> <i class="bi bi-journal-richtext"></i><span
				class="label">시설물 관리</span>
		</a></li>
		<!-- 필요 메뉴를 계속 추가하세요 -->
	</ul>
</aside>
