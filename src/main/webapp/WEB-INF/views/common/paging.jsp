<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* 페이징 전체를 감싸는 컨테이너 */
.pagination-container {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;           /* 버튼 사이의 간격 */
    margin: 35px 0;     /* 위아래 여백 */
}

/* 모든 페이지 버튼 공통 스타일 (밑줄 제거 및 터치 영역 확보) */
.pagination-container .page-link {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-width: 40px;
    height: 40px;
    padding: 0 14px;
    font-size: 14px;
    font-weight: 500;
    color: #2D6A4F;             /* [메인 컬러] 기본 글씨 색상 */
    text-decoration: none;      /* ❌ 밑줄 제거 */
    background-color: #FFFFFF;
    border: 1px solid #B7E4C7;  /* [포인트 컬러] 연한 민트빛 테두리 */
    border-radius: 4px;         /* 부드러운 사각 테두리 */
    box-sizing: border-box;
    transition: all 0.2s ease-in-out;
}

/* 이전 / 다음 텍스트 버튼 스타일 */
.pagination-container .page-link.prev-next {
    font-weight: 600;
}

/* 마우스 호버(Hover) 및 키보드 탭(Focus) 시 스타일 */
.pagination-container a.page-link:hover,
.pagination-container a.page-link:focus {
    color: #FFFFFF;             /* 명도 대비를 위해 글씨는 흰색 */
    background-color: #49A47A;  /* [서브 컬러] 중간 그린 배경 */
    border-color: #49A47A;
    outline: none;
    box-shadow: 0 0 0 3px rgba(73, 164, 122, 0.4); /* 서브 컬러 포커스 링 */
}

/* 현재 내가 보고 있는 페이지 (Strong) 스타일 */
.pagination-container .page-link.active {
    color: #FFFFFF;             /* 흰색 글씨 */
    background-color: #2D6A4F;  /* [메인 컬러] 가장 짙은 그린 배경 */
    border-color: #2D6A4F;
    font-weight: 700;
    cursor: default;            /* 클릭 불가 기본 커서 표기 */
}
</style>

<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />

<nav class="pagination-container" aria-label="페이지 선택">
    
    <c:if test="${!pageInfo.isFirstPage}">
        <a class="page-link prev-next" 
           href="${currentURI}?page=${pageInfo.pageNum - 1}" 
           aria-label="이전 페이지 이동">이전</a>
    </c:if>

    <c:forEach var="pageNo" items="${pageInfo.navigatepageNums}">
        <c:choose>
            <c:when test="${pageNo == pageInfo.pageNum}">
                <strong class="page-link active" aria-current="page">${pageNo}</strong>
            </c:when>
            <c:otherwise>
                <a class="page-link" 
                   href="${currentURI}?page=${pageNo}">${pageNo}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <c:if test="${!pageInfo.isLastPage}">
        <a class="page-link prev-next" 
           href="${currentURI}?page=${pageInfo.pageNum + 1}" 
           aria-label="다음 페이지 이동">다음</a>
    </c:if>
    
</nav>