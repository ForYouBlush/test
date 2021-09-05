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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
            showRemarkList()
            showActivity()
            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function(){
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#remarkBody").on("mouseover",".remarkDiv",function(){
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout",".remarkDiv",function(){
                $(this).children("div").children("div").hide();
            })

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });

            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });


            //关联市场活动按钮的监听事件
            $("#showActivityBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/showActivityNotInClueId.do",
                    data:{
                        "id":"${c.id}"
                    },
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        var html=""
                        $.each(data,function (i,n) {
                                html+='<tr>'
                                html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
                                html+='<td>'+n.name+'</td>'
                                html+='<td>'+n.startDate+'</td>'
                                html+='<td>'+n.endDate+'</td>'
                                html+='<td>'+n.owner+'</td>'
                                html+='</tr>'
                        })
                        $("#activityModalBody").html(html)
                        //打开模态窗口
                        $("#bundModal").modal("show")
                    }
                })
            })

            //条件查询的监听事件，查询带有条件的市场活动信息
            $("#search-activity").keydown(function (event) {
                if (event.keyCode==13){
                    $.ajax({
                        url:"workbench/clue/showActivityByNameNotInClueId.do",
                        data:{
                            "name": $.trim($("#search-activity").val()),
                            "cid":"${c.id}"
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            var html=""
                            $.each(data,function (i,n) {
                                html+='<tr>'
                                html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
                                html+='<td>'+n.name+'</td>'
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

            //为全选的复选框绑定事件，触发全选操作
            $("#quanxuan").click(function () {
                $("input[name=xz]").prop("checked",this.checked)
            })
            //单选按钮影响全选按钮的状态
            $("#clueBody").on("click",$("input[name=xz]"),function () {
                $("#quanxuan").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
            })

            //关联按钮单击事件，关联市场活动，局部刷新市场活动列表
            $("#bindBtn").click(function () {
                var $xz=$("input[name=xz]:checked")
                if ($xz.length==0){
                    alert("请选择你要关联的市场活动")
                }else{
                    var array=new Array()
                    for (var i = 0; i <$xz.length ; i++) {
                        array[i]=$xz[i].value
                    }
                    $.ajax({
                        url:"workbench/clue/bindActivity.do",
                        data:{
                            "aid":array,
                            "cid":"${c.id}"
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if (data.success){
                                //清空复选框，清除条件查询的内容，局部刷新市场活动列表关闭模态窗口
                                $("#quanxuan").prop("checked",false)
                                $("#search-activity").val("")
                                showActivity()
                                $("#bundModal").modal("hide")
                            } else{
                                alert("关联市场活动失败")
                            }
                        }
                    })
                }
            })


            //编辑按钮的单击事件，打开模态窗口
            $("#updateBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/edit.do",
                    data:{
                        "id":"${param.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        //获得userList和clueList
                        var html=""
                        $.each(data.userList,function (i,n) {
                            html+="<option value='"+n.id+"'>"+n.name+"</option>"
                        })
                        $("#edit-owner").html(html)
                        $("#edit-id").val(data.clueList.id)
                        $("#edit-owner").val(data.clueList.owner)
                        $("#edit-company").val(data.clueList.company)
                        $("#edit-appellation").val(data.clueList.appellation)
                        $("#edit-fullname").val(data.clueList.fullname)
                        $("#edit-job").val(data.clueList.job)
                        $("#edit-email").val(data.clueList.email)
                        $("#edit-phone").val(data.clueList.phone)
                        $("#edit-website").val(data.clueList.website)
                        $("#edit-mphone").val(data.clueList.mphone)
                        $("#edit-state").val(data.clueList.state)
                        $("#edit-source").val(data.clueList.source)
                        $("#edit-description").val(data.clueList.description)
                        $("#edit-contactSummary").val(data.clueList.contactSummary)
                        $("#edit-nextContactTime").val(data.clueList.nextContactTime)
                        $("#edit-address").val(data.clueList.address)
                    }
                })
                //打开模态窗口
                $("#editClueModal").modal("show")

            })





            //修改按钮的单击事件，修改线索的信息
            $("#update").click(function () {
                if ($.trim($("#edit-company").val())==null||$.trim($("#edit-company").val())==""){
                    alert("您有信息未完善！")
                }
                else if ($.trim($("#edit-fullname").val())==null||$.trim($("#edit-fullname").val())==""){
                    alert("您有信息未完善！")
                }else{
                    $.ajax({
                        url:"workbench/clue/updateClue.do",
                        data:{
                            "id":"${param.id}",
                            "fullname":$.trim($("#edit-fullname").val()),
                            "appellation":$.trim($("#edit-appellation").val()),
                            "owner":$.trim($("#edit-owner").val()),
                            "company":$.trim($("#edit-company").val()),
                            "job":$.trim($("#edit-job").val()),
                            "email":$.trim($("#edit-email").val()),
                            "phone":$.trim($("#edit-phone").val()),
                            "website":$.trim($("#edit-website").val()),
                            "mphone":$.trim($("#edit-mphone").val()),
                            "state":$.trim($("#edit-state").val()),
                            "source":$.trim($("#edit-source").val()),
                            "description":$.trim($("#edit-description").val()),
                            "contactSummary":$.trim($("#edit-contactSummary").val()),
                            "nextContactTime":$.trim($("#edit-nextContactTime").val()),
                            "address":$.trim($("#edit-address").val())
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if (data.success){
                                // pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
                                //     ,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                                $("#editClueModal").modal("hide")
                            }else{
                                alert("更新线索失败")
                            }
                        }
                    })
                }
            })


            //删除按钮的单击事件，删除这个页面的线索然后跳转回index界面
            $("#deleteBtn").click(function () {
                if(confirm("你确定要删除这条线索吗")){
                    $.ajax({
                        url:"workbench/clue/deleteClueById.do",
                        data:{
                            "id":"${param.id}"
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if (data.success){
                                //局部刷新页面
                               window.location.href="workbench/clue/index.jsp"
                            } else{
                                alert("删除失败")
                            }
                        }
                    })
                }
            })


            //执行添加备注操作
            $("#saveRemarkBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/saveRemark.do",
                    data:{
                        "noteContent":$.trim($("#remark").val()),
                        "clueId":"${param.id}",
                        "createBy":"${c.createBy}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.success){
                            var html=""
                            $("#remark").val("")
                            html+='<div class="remarkDiv" id="'+data.cr.id+'" style="height: 60px;" >'
                            html+='<img title="'+data.cr.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                            html+='<div style="position: relative; top: -40px; left: 40px;" >'
                            html+='<h5>'+data.cr.noteContent+'</h5>'
                            html+='<font color="gray">线索</font> <font color="gray">-</font> <b>'+"${c.fullname}"+'</b> <small style="color: gray;"> '+data.cr.createTime+' 由'+data.cr.createBy+'</small>'
                            html+=' <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                            html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;" onclick="editRemark(\''+data.cr.id+'\')"></span></a>'
                            html+='&nbsp;&nbsp;&nbsp;&nbsp;'
                            html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;" onclick="removeRemark(\''+data.cr.id+'\')"></span></a>'
                            html+='</div>'
                            html+='</div>'
                            html+='</div>'
                            $("#remarkDiv").before(html)
                        } else{
                            alert("添加备注失败")
                        }
                    }
                })
            })




        });


        //以下是声明函数
        //展现市场活动列表
        function showActivity() {
            $.ajax({
                url:"workbench/clue/showActivity.do",
                data:{
                    "id":"${c.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html=""
                    $.each(data,function (i,n) {
                        html+='<tr>'
                        html+='<td>'+n.name+'</td>'
                        html+='<td>'+n.startDate+'</td>'
                        html+='<td>'+n.endDate+'</td>'
                        html+='<td>'+n.owner+'</td>'
                        html+='<td><a href="javascript:void(0);"  style="text-decoration: none;" onclick="unbind(\''+n.id+'\')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>'
                        html+='</tr>'
                    })
                    $("#activityBody").html(html)
                }
            })
        }

        //解除关联
        function unbind(id) {
            if (confirm("请问你是否确定解除关联")){
                $.ajax({
                    url:"workbench/clue/unbind.do",
                    data:{
                        "id":id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.success){
                            showActivity()
                        } else{
                            alert("解除关联失败")
                        }
                    }
                })
            }

        }


        //展现备注
        function showRemarkList() {
            var html=""
            $.ajax({
                url:"workbench/clue/remark.do",
                data:{
                    "id":"${param.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    $.each(data,function (i,n) {
                        html+='<div class="remarkDiv" id="'+n.id+'" style="height: 60px;" >'
                        html+='<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html+='<div style="position: relative; top: -40px; left: 40px;" >'
                        html+='<h5 id="h'+n.id+'">'+n.noteContent+'</h5>'
                        html+='<font color="gray">线索</font> <font color="gray">-</font> <b>'+"${c.fullname}"+'</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>'
                        html+=' <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #ff0000;" onclick="editRemark(\''+n.id+'\')"></span></a>'
                        html+='&nbsp;&nbsp;&nbsp;&nbsp;'
                        html+='<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #ff0000;" onclick="removeRemark(\''+n.id+'\')"></span></a>'
                        html+='</div>'
                        html+='</div>'
                        html+='</div>'
                    })
                    $("#remarkDiv").before(html)
                }
            })
        }


        //删除备注按钮
        function removeRemark(id) {
            if (confirm("您确定删除这条备注吗")){
                //发起ajax删除数据
                $.ajax({
                    url:"workbench/clue/deleteRemark.do",
                    data:{
                        "id":id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.success){
                            //局部刷新备注页面
                            //这样做不行，因为before()方法不会清空已经生成的内容
                            //showRemarkList()
                            $("#"+id).remove()
                        } else{
                            alert("删除备注失败")
                        }
                    }
                })

            }

        }


        //执行打开更新备注的模态窗口
        function editRemark(id) {
            var noteContent=$("#h"+id).html()
            $("#noteContent").val(noteContent)
            //打开模态窗口
            $("#editRemarkModal").modal("show")
            //执行更新备注操作
            $("#updateRemarkBtn").click(function () {
                if($.trim($("#noteContent").val())==""){
                    alert("备注内容不能为空")
                }else{
                    //发起ajax获取数据
                    $.ajax({
                        url:"workbench/clue/updateRemark.do",
                        data:{
                            "id":id,
                            "noteContent":$.trim($("#noteContent").val())
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            //刷新页面
                            if (data.success){
                                $("#h"+id).html($.trim($("#noteContent").val()))
                                $("#s"+id).html((data.cr.editTime)+' 由'+(data.cr.editBy))
                                //关闭模态窗口
                                $("#editRemarkModal").modal("hide")
                            }else{
                                alert("修改备注失败")
                            }
                        }
                    })
                }
            })
        }




    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"  id="search-activity" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="quanxuan"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activityModalBody">

                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bindBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                               <c:forEach var="a" items="${appellationList}">
                                   <option value="${a.value}">${a.text}</option>
                               </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <c:forEach var="a" items="${clueStateList}">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach var="a" items="${sourceList}">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${c.fullname}${c.appellation} <small>${c.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${c.id}&fullname=${c.fullname}&appellation=${c.appellation}&company=${c.company}&owner=${c.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
        <button type="button" class="btn btn-default" data-toggle="modal" id="updateBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.fullname}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b> ${c.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead >
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr>--%>
                    <%--<td>发传单</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td>发传单</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--</tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" id="showActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>