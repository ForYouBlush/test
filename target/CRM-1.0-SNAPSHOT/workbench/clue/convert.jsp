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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function(){

            //日期选择器
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#isCreateTransaction").click(function(){
                if(this.checked){
                    $("#create-transaction2").show(200);
                }else{
                    $("#create-transaction2").hide(200);
                }
            });


            //搜索图片按钮的单击事件，打开搜索模态窗口
            $("#searchModalBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/getActivityList.do",
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
                        $("#searchActivityBody").html(html)
                        $("#searchActivityModal").modal("show")
                    }
                })
            })
            //查询内容文本的回车事件，通过内容查询市场活动信息
            $("#searchContent").keydown(function (event) {
                if (event.keyCode==13){
                    $.ajax({
                        url:"workbench/clue/getActivityListByName.do",
                        data:{
                            "name":$.trim($("#searchContent").val())
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
                            $("#searchActivityBody").html(html)

                        }
                    })
                    return false
                }
            })
            //模态窗口的提交按钮的单机事件，保存市场活动信息
            $("#saveBtn").click(function () {
                $xz=$("input[name=xz]:checked")
                if ($xz==0) {
                    alert("请选择你要提交的市场活动信息")
                }else{
                    //把内容放入到文本框中
                    $("#activity").val($("#"+$xz.val()).html())
                    $("#hidden-id").val($xz.val())
                    //清空查询内容，关闭模态窗口
                    $("#searchContent").val("")
                    $("#searchActivityModal").modal("hide")
                }
            })


            //转换按钮的单击事件，把线索转换成联系人和客户，然后删除这条线索及相关信息
            $("#tranBtn").click(function () {
                if (confirm("您确定要进行转换吗")){
                    if ($("#isCreateTransaction").prop("checked")) {

                        $("#tranForm").submit()
                    }else{
                        //不需要创建交易
                        window.location.href="workbench/clue/convert.do?clueId=${param.id}"
                    }
                }
            })
        });
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog" >
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询"  id="searchContent">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="searchActivityBody">
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary"  id="saveBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${param.fullname}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

    <form method="post" action="workbench/clue/convert.do" id="tranForm">
        <input type="hidden" id="hidden-id" name="activityId">
        <input type="hidden" value="a" name="flag">
        <input type="hidden" value="${param.id}" name="clueId" >
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney" name="money">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="" name="name">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage"  class="form-control" name="stage">
                <c:forEach items="${stageList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search" ></span></a></label>
            <input type="text" class="form-control" id="activity"   placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button"  id="tranBtn" value="转换">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>