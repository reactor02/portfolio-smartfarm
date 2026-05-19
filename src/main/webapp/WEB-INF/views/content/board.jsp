<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
         <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    

    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>

<script> 
	window.addEventListener('load', ()=> {
		bind()
	})
	
	function bind(){
		document.getElementById("list")
		.addEventListener('click',function(event){
			console.log('submit')
			
			event.preventDefault();
			
			fetch("./list", {
				method: 'get'
			}).then(
				resp => resp.json()		
			).then(function(data){
				console.log(data)
				console.log('data.list',data.length)
				
				document.getElementById("tbody").innerHTML=``
				for(let i = 0; i<data.length;i++){
					document.getElementById("tbody").innerHTML+=`
					<tr>
						<td>\${data[i].board_num}</td>
						<td>\${data[i].category}</td>
						<td>\${data[i].title}</td>
						<td>\${data[i].content}</td>
						<td>\${data[i].view_cnt}</td>
						<td>\${data[i].created_at}</td>
						<td>\${data[i].updated_at}</td>
						<td>\${data[i].board_status}</td>
						<td>\${data[i].files_num}</td>
						<td>\${data[i].emp_num}</td>
						
					</tr>
					`
				}
			})
		})
		
	}
</script>
</head>
<body>

<h1>board</h1>


<input type = "submit" id="list" value="리스트">

<table border = "1"> 
	<thead> 
		<tr>
			<th>no.</th>
			<th>카테고리</th>
			<th>제목</th>
			<th>내용</th>
			<th>조회횟수</th>
			<th>생성일</th>
			<th>수정일</th>
			<th>상태</th>
			<th>파일no.</th>
			<th>작성자</th>
		</tr>
	</thead>
	<tbody id = "tbody"></tbody>
</table>



</body>
</html>