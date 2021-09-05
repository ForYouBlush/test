<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--分页功能的插件--%>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		pageList(1,2)



		//查询按钮的单击事件
		$("#searchBtn").click(function () {
			//点击查询的时候要把表单域中的信息保存起来
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-customerName").val($.trim($("#search-customerName").val()))
			$("#hidden-stage").val($.trim($("#search-stage").val()))
			$("#hidden-type").val($.trim($("#search-type").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-source").val($.trim($("#search-source").val()))
			$("#hidden-contactsName").val($.trim($("#search-contactsName").val()))
			pageList(1
					,$("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
		})



		//为全选的复选框绑定事件，触发全选操作
		$("#quanxuan").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//单选按钮影响全选按钮的状态
		$("#tranBody").on("click",$("input[name=xz]"),function () {
			$("#quanxuan").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})


		//删除按钮的单击事件，删除选中的线索
		$("#deleteBtn").click(function () {
			var $xz=$("input[name=xz]:checked")
			if ($xz.length<1){
				alert("请选择你要删除的交易")
				return;
			}
			if(confirm("你确定要删除选中的交易吗")){
				var ids=new Array()
				$.each($xz,function (i,n) {
					ids[i]=n.value
				})
				$.ajax({
					url:"workbench/transaction/deleteTran.do",
					data:{
						"id":ids
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.success){
							//局部刷新页面
							pageList(1
									,$("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
						} else{
							alert("删除失败")
						}
					}
				})
			}
		})









	});




	//以下是单独定义的函数

	//分页函数
	function pageList(pageNo,pageSize) {
		//将触发该函数去掉全选框的状态
		$("#quanxuan").prop("checked",false)
		//查询前，将隐藏表单域中的信息取出来，重新赋予到搜索表单域中
		$("#search-name").val($.trim($("#hidden-name").val()))
		$("#search-customerName").val($.trim($("#hidden-customerName").val()))
		$("#search-stage").val($.trim($("#hidden-stage").val()))
		$("#search-type").val($.trim($("#hidden-type").val()))
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-source").val($.trim($("#hidden-source").val()))
		$("#search-contactsName").val($.trim($("#hidden-contactsName").val()))
		$.ajax({
			url:"workbench/transaction/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"customerName":$.trim($("#search-customerName").val()),
				"stage":$.trim($("#search-stage").val()),
				"type":$.trim($("#search-type").val()),
				"owner":$.trim($("#search-owner").val()),
				"source":$.trim($("#search-source").val()),
				"contactsName":$.trim($("#search-contactsName").val()),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//返回tranList和total总条数
				var html="";
				$.each(data.dataList,function (i,n) {
					html+='<tr>'
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html+=' <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.name+'</a></td>'
					html+='<td>'+n.customerId+'</td>'
					html+='<td>'+n.stage+'</td>'
					html+='<td>'+n.type+'</td>'
					html+='<td>'+n.owner+'</td>'
					html+='<td>'+n.source+'</td>'
					html+='<td>'+n.contactsId+'</td>'
					html+='</tr>'

				})
				$("#tranBody").html(html)
				//计算总页数
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1
				//处理完数据之后 使用分页组件
				$("#tranPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数在点击分页组件的时候触发
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})
	}

	//编辑按钮的单击事件，跳转到后台然后重定向
	function edit() {
		var $xz=$("input[name=xz]:checked")
		if ($xz.length!=1){
			alert("请选择一条线索进行修改")
			return false
		}
		window.location.href="workbench/transaction/edit.do?id="+$xz.val()+""
	}



	
</script>
</head>
<body>

	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-customerName">
	<input type="hidden" id="hidden-stage">
	<input type="hidden" id="hidden-type">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-contactsName">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="s">
							<option value="${s.value}">${s.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
						  <c:forEach items="${transactionTypeList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="edit()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="quanxuan" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">

					<div id="tranPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>