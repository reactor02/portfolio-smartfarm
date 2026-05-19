<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
         <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    

    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

<style>
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
</style>

</head>
<body>

<h2>사원 정보 전체 목록</h2>

<table>
    <thead>
        <tr>
            <th>사원명</th>
            <th>비밀번호</th>
            <th>권한레벨</th>
            <th>전화번호</th>
            <th>입사일</th>
            <th>상태</th>
            <th>퇴사일</th>
            <th>개인정보/비고</th>
            <th>부서번호</th>
        </tr>
    </thead>
    <tbody>
        <!-- 컨트롤러에서 보낸 empList를 순회합니다 -->
        <c:forEach var="x" items="${empList}">
            <tr>
                <td><c:out value="${x.ename}" /></td>
                <td><c:out value="${x.pw}" /></td>
                <td><c:out value="${x.e_level}" /></td>
                <td><c:out value="${x.tel}" /></td>
                <td><c:out value="${x.hire_date}" /></td>
                <td><c:out value="${x.status}" /></td>
                <td><c:out value="${x.termination_date}" /></td> <!-- 자바 관례에 맞게 소문자 t 권장 -->
                <td><c:out value="${x.privat}" /></td>
                <td><c:out value="${x.dept_num}" /></td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<h1>content</h1>


</body>
</html>