<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<base href="<%=basePath%>">
<head>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        $(function(){
            pageList(1,2)
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //添加按钮的单击事件 打开模态窗口
            $("#addBtn").click(function () {

                /*
                * 操作模态窗口的方式：
                *               需要操作的模态窗口的jQuery对象，调用modal()方法  参数有两种 show：打开窗口   hide：隐藏窗口
                * */
                //alert("1234")
                //发起ajax请求获取user数据
                $.ajax({
                    url:"workbench/activity/getUserList.do",
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        var html=""
                        var id="${user.id}"
                        $.each(data,function (i,n) {
                            html+="<option value='"+n.id+"'>"+n.name+"</option>"
                        })
                        $("#create-owner").html(html)
                        //默认选择当前登录账号的姓名
                        $("#create-owner").val(id)
                    }
                })
                //展现模态窗口
                $("#createActivityModal").modal("show")
            })


            //保存按钮的单击事件
            $("#saveBtn").click(function () {
                //发起ajax请求
                $.ajax({
                    url:"workbench/activity/save.do",
                    data:{
                        "owner":$.trim($("#create-owner").val()),
                        "name":$.trim($("#create-name").val()),
                        "startDate":$.trim($("#create-startDate").val()),
                        "endDate":$.trim($("#create-endDate").val()),
                        "cost":$.trim($("#create-cost").val()),
                        "description":$.trim($("#create-description").val()),

                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        //返回一个{"success":true/false}
                        if (data.success){
                            //保存成功,局部刷新页面
                            pageList(1
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            //重置表单内容
                            $("#saveForm")[0].reset()
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide")
                        } else{
                            alert("保存市场活动失败")
                        }
                    }
                })
            })


            //查询按钮的单击事件
            $("#searchBtn").click(function () {
                //点击查询的收要把表单域中的信息保存起来
                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-startDate").val($.trim($("#search-startDate").val()))
                $("#hidden-endDate").val($.trim($("#search-endDate").val()))
                pageList(1
                    ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })


            //为全选的复选框绑定事件，触发全选操作
            $("#quanxuan").click(function () {
                   $("input[name=xz]").prop("checked",this.checked)
            })
            /*因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
            动态生成的元素，我们要以on方法的形式来触发事件
            语法:
                $(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
               */
            $("#searchBody").on("click",$("input[name=xz]"),function () {
                $("#quanxuan").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
            })


            //为删除按钮绑定事件，执行市场活动删除操作
            $("#deleteBtn").click(function () {
                //找到复选框中所有checked的复选框的jQuery对象
                var $xz=$("input[name=xz]:checked")
                if ($xz.length==0){
                    alert("请选择需要删除的记录")
                }else{
                    if(confirm("确定删除所选中的记录吗")){
                        var param=new Array();
                        for (var i = 0; i <$xz.length ; i++) {
                            param[i]=$xz[i].value
                        }
                        //执行删除ajax操作
                        $.ajax({
                            url:"workbench/activity/delete.do",
                            data:{
                                "param":param
                            },
                            type:"get",
                            dataType:"json",
                            success:function (data) {
                                //返回success：true/false
                                if (data.success){
                                    pageList(1
                                        ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                                } else{
                                    alert("删除市场活动失败")
                                }
                            }
                        })
                    }

                }
            })


            //修改按钮绑定单机事件,打开模态窗口
            $("#editBtn").click(function () {
                var $xz=$("input[name=xz]:checked");
                if ($xz.length==0){
                    alert("请选择需要修改的记录")
                }else if($xz.length>1){
                    alert("只能选择一条记录进行修改")
                }else{
                    var id=$xz.val()
                    $.ajax({
                        url:"workbench/activity/edit.do",
                        data:{
                            "id":id
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            //拿到 userList和activityList
                            var html=""
                            $.each(data.userList,function (i,n) {
                                html+="<option value='"+n.id+"'>"+n.name+"</option>"
                            })
                            $("#edit-owner").html(html)
                            //处理activityList数据
                            $("#edit-id").val(data.a.id)
                            $("#edit-name").val(data.a.name)
                            $("#edit-owner").val(data.a.owner)
                            $("#edit-startDate").val(data.a.startDate)
                            $("#edit-endDate").val(data.a.endDate)
                            $("#edit-cost").val(data.a.cost)
                            $("#edit-description").val(data.a.description)
                            $("#editActivityModal").modal("show")
                        }
                    })

                }
            })
            //更新按钮的单击事件
            $("#updateBtn").click(function () {
                    //发起ajax请求更新数据
                    $.ajax({
                        url:"workbench/activity/update.do",
                        data:{
                            "id":$.trim($("#edit-id").val()),
                            "owner":$.trim($("#edit-owner").val()),
                            "name":$.trim($("#edit-name").val()),
                            "startDate":$.trim($("#edit-startDate").val()),
                            "endDate":$.trim($("#edit-endDate").val()),
                            "cost":$.trim($("#edit-cost").val()),
                            "description":$.trim($("#edit-description").val()),
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            //返回一个{"success":true/false}
                            if (data.success){
                                //修改成功,局部刷新页面
                                pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                    ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                                //重置表单内容
                                // $("#saveForm")[0].reset()
                                //关闭模态窗口
                                $("#editActivityModal").modal("hide")
                            } else{
                                alert("修改市场活动失败")
                            }
                        }
                    })


            })
            
            
            //分页函数
            function pageList(pageNo,pageSize) {
                //将触发该函数去掉全选框的状态
                $("#quanxuan").prop("checked",false)
                //查询前，将隐藏表单域中的信息取出来，重新赋予到搜索表单域中
                $("#search-name").val($.trim($("#hidden-name").val()))
                $("#search-owner").val($.trim($("#hidden-owner").val()))
                $("#search-startDate").val($.trim($("#hidden-startDate").val()))
                $("#search-endDate").val($.trim($("#hidden-endDate").val()))
                $.ajax({
                    url:"workbench/activity/pageList.do",
                    data:{
                        "pageNo":pageNo,
                        "pageSize":pageSize,
                        "name":$.trim($("#search-name").val()),
                        "owner":$.trim($("#search-owner").val()),
                        "startDate":$.trim($("#search-startDate").val()),
                        "endDate":$.trim($("#search-endDate").val()),
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        //返回activityList和total总条数
                        var html="";
                        $.each(data.dataList,function (i,n) {
                                html+='<tr class="active">'
                                html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
                                html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>'
                                html+='<td>'+n.owner+'</td>'
                                html+='<td>'+n.startDate+'</td>'
                                html+='<td>'+n.endDate+'</td>'
                                html+='</tr>'

                        })
                        $("#searchBody").html(html)
                        //计算总页数
                        var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1
                        //处理完数据之后 使用分页组件
                        $("#activityPage").bs_pagination({
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
        });

    </script>
</head>
<body>
<%--创建隐藏表单域来保存查询的值--%>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">
<input type="hidden" id="edit-id">
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="saveForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" >
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" >
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate" >
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <%--
                data-toggle="modal" data-target="#createActivityModal" 是bootstrap的模态窗口
                                     不能写死   写死了就不能执行其他操作了  需要在js中执行
                --%>
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="quanxuan"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="searchBody">
                <%--<tr class="active">--%>
                    <%--<td><input type="checkbox" /></td>--%>
                    <%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                <%--</tr>--%>
                <%--<tr class="active">--%>
                    <%--<td><input type="checkbox" /></td>--%>
                    <%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                <%--</tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>