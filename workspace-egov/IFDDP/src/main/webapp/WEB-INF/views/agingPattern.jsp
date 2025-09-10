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
