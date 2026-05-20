<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



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