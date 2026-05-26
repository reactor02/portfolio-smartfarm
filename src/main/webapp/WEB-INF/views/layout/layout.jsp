<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NodeFarm MES</title>
<style>
        :root { --m-cl: #2D6A4F; --s-cl: #49A47A; --p-cl: #B7E4C7; --bg: #F8F9FA; --txt: #333; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Malgun Gothic', sans-serif; color: var(--txt); background-color: var(--bg); }
        .mat-all { display: flex; flex-direction: column; min-height: 100vh; }
        .hdr { display: flex; justify-content: space-between; align-items: center; background-color: var(--m-cl); color: #FFF; padding: 0 20px; height: 60px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .hdr-logo-area { display: flex; align-items: center; text-decoration: none; color: #FFF; }
        .hdr-logo-img { height: 40px; width: auto; margin-right: 10px; }
        .hdr-logo-txt { font-size: 1.4rem; font-weight: bold; letter-spacing: -1px; }
        .hdr-user { font-size: 0.9rem; }
        .hdr-user a { color: var(--p-cl); text-decoration: none; margin-left: 10px; }
        .wrap { display: flex; flex: 1; }
        .side { width: 240px; background-color: #FFF; border-right: 1px solid #DDD; }
        .nav-list { list-style: none; }
        .nav-item { border-bottom: 1px solid #EEE; }
        .nav-btn { display: block; padding: 1rem 1.5rem; cursor: pointer; font-weight: bold; color: var(--m-cl); transition: background 0.3s; text-decoration: none; user-select: none; }
        .nav-btn:hover { background-color: var(--p-cl); }
        .sub-nav { list-style: none; display: none; background-color: #F9FDFB; }
        .sub-nav.on { display: block; }
        .sub-nav a { display: block; padding: 0.7rem 1.5rem 0.7rem 2.5rem; font-size: 0.9rem; color: #555; text-decoration: none; }
        .sub-nav a:hover { color: var(--m-cl); font-weight: bold; text-decoration: underline; text-underline-offset: 4px; }
        .cont { flex: 1; padding: 2rem; background-color: #FFF; }
        .ftr { text-align: center; padding: 1rem 0; background-color: #EEE; font-size: 0.8rem; color: #777; margin-top: auto; }

        /* ── 반응형 (태블릿 ≤ 768px) ── */
        @media (max-width: 768px) {
            .side { display: none; }
            .cont { padding: 1.2rem 1rem; }
        }
        /* ── 반응형 (모바일 ≤ 480px) ── */
        @media (max-width: 480px) {
            .cont { padding: 0.8rem; }
            .hdr  { padding: 0 12px; }
            .hdr-logo-txt { font-size: 1.1rem; }
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/modal.css">
    <script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
</head>
<body>
<div class="mat-all">
    <tiles:insertAttribute name="header" />
    <div class="wrap">
        <tiles:insertAttribute name="aside" />
        <main class="cont">
            <tiles:insertAttribute name="content" />
        </main>
    </div>
    <tiles:insertAttribute name="footer" />
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const toggles = document.querySelectorAll('.toggle-btn');
        toggles.forEach(btn => {
            btn.addEventListener('click', () => {
                const subNav = btn.nextElementSibling;
                if (subNav && subNav.classList.contains('sub-nav')) {
                    subNav.classList.toggle('on');
                }
            });
        });
    });
</script>
</body>
</html>