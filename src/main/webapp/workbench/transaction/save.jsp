<%@ page import="java.util.Map" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";

	Map<String ,String> pmap= (Map<String, String>) application.getAttribute("pmap");
	ObjectMapper om=new ObjectMapper();
	String json=om.writeValueAsString(pmap);
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
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">
		$(function () {
			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});

			//客户名称自动补全
			$("#create-customerName").change(function () {
				$("#create-customerName").typeahead({
					source: function (query, process) {
						$.get(
								"workbench/transaction/getCustomerName.do",
								{ "name" : query },
								function (data) {
									//alert(data);
									process(data);
								},
								"json"
						);
					},
					delay: 1000
				});
			})


			//市场活动源  打开模态窗口
			$("#findActivityList").click(function () {
				$.ajax({
					url:"workbench/transaction/showActivityList.do",
					type:"get",
					dataType:"json",
					success:function (data) {
						var html=""
						$.each(data,function (i,n) {
							html+='<tr>'
							html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>'
							html+='<td id="'+n.id+'">'+n.name+'</td>'
							html+='<td>'+n.startDate+'</td>'
							html+='<td>'+n.endDate+'</td>'
							html+='<td>'+n.owner+'</td>'
							html+='</tr>'
						})
						$("#activityModalBody").html(html)
						//打开模态窗口
						$("#findMarketActivity").modal("show")
					}
				})
			})


			//市场活动条件查询的监听事件，查询带有条件的市场活动信息
			$("#search-activity").keydown(function (event) {
				if (event.keyCode==13){
					$.ajax({
						url:"workbench/transaction/showActivityByName.do",
						data:{
							"name": $.trim($("#search-activity").val())
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html=""
							$.each(data,function (i,n) {
								html+='<tr>'
								html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>'
								html+='<td id="'+n.id+'">'+n.name+'</td>'
								html+='<td>'+n.startDate+'</td>'
								html+='<td>'+n.endDate+'</td>'
								html+='<td>'+n.owner+'</td>'
								html+='</tr>'
							})
							$("#activityModalBody").html(html)
						}
					})
					return false
				}
			})




			//市场活动列表模态窗口的提交按钮单击事件  把选中的市场活动填充到内容上
			$("#submitBtn").click(function () {
				var $xz=$("input[name=xz]:checked")
				//将选中的市场活动名字填充到市场活动源中
				$("#create-activitySrc").val($("#"+$xz.val()).html())
				$("#hidden-activityId").val($xz.val())
				$("#findMarketActivity").modal("hide")
			})



			//联系人名称  打开模态窗口
			$("#findContactsList").click(function () {
				$.ajax({
					url:"workbench/transaction/showContactsList.do",
					type:"get",
					dataType:"json",
					success:function (data) {
						var html=""
						$.each(data,function (i,n) {
							html+='<tr>'
							html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>'
							html+='<td id="'+n.id+'">'+n.fullname+'</td>'
							html+='<td>'+n.email+'</td>'
							html+='<td>'+n.mphone+'</td>'
							html+='</tr>'
						})
						$("#contactsModalBody").html(html)
						//打开模态窗口
						$("#findContacts").modal("show")
					}
				})
			})



			//联系人条件查询的监听事件，查询带有条件的联系人信息
			$("#search-contacts").keydown(function (event) {
				if (event.keyCode==13){
					$.ajax({
						url:"workbench/transaction/showContactsByName.do",
						data:{
							"name": $.trim($("#search-contacts").val())
						},
						type:"get",
						dataType:"json",
						success:function (data) {
							var html=""
							$.each(data,function (i,n) {
								html+='<tr>'
								html+='<td><input type="radio" name="xz" value="'+n.id+'"/></td>'
								html+='<td id="'+n.id+'">'+n.fullname+'</td>'
								html+='<td>'+n.email+'</td>'
								html+='<td>'+n.mphone+'</td>'
								html+='</tr>'
							})
							$("#contactsModalBody").html(html)
						}
					})
					return false
				}
			})





			//联系人列表模态窗口的提交按钮单击事件  把选中的联系人填充到内容上
			$("#submitContactsBtn").click(function () {
				var $xz=$("input[name=xz]:checked")
				//将选中的市场活动名字填充到市场活动源中
				$("#create-contactsName").val($("#"+$xz.val()).html())
				$("#hidden-contactsId").val($xz.val())
				$("#findContacts").modal("hide")
			})



			//阶段的change事件，自动填充可能性的内容
			$("#create-stage").change(function () {
				var json=<%=json%>
				var value=$("#create-stage").val()
				$("#create-possibility").val(json[value])
			})


			//保存按钮的单击事件   提交表单  新增一条交易 跳转到index.jsp
			$("#saveBtn").click(function () {
				if ($("#create-owner").val() == "" || $("#create-expectedClosingDate").val() == "" || $("#create-name").val() == ""
				||$("#create-customerName").val()==""||$("#create-stage").val()==""){
					alert("您有信息未完善")
					return false
				}
				$("#TranForm").submit()

			})



		})
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="search-activity">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityModalBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询" id="search-contacts">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsModalBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/index.jsp'" >取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" id="TranForm" action="workbench/transaction/save.do" method="post" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner" name="owner">
				 <c:forEach items="${userList}" var="u">
					 <option value="${u.id}" ${user.id eq u.id?"selected":""}>${u.name}</option>
				 </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建" name="customerName">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage" name="stage">
			  	<option></option>
			  	<c:forEach var="s" items="${stageList}">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach var="t" items="${transactionTypeList}">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach var="s" items="${sourceList}">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"  id="findActivityList"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"  id="findContactsList"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		<input type="hidden" id="hidden-activityId" name="activityId">
		<input type="hidden" id="hidden-contactsId" name="contactsId">
	</form>
</body>
</html>