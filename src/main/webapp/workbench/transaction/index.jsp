<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


    <script type="text/javascript">

        $(function () {

            pageList(1,2);

            $(window).keydown(function (event) {

                //alert(event.keyCode);

                //如果取得的键位的码值为13，表示敲的是回车键
                if (event.keyCode == 13) {
                    $("#hidden-name").val($.trim($("#search-name").val()));
                    $("#hidden-customerId").val($.trim($("#search-customerId").val()));
                    $("#hidden-stage").val($.trim($("#search-stage").val()));
                    $("#hidden-type").val($.trim($("#search-type").val()));
                    $("#hidden-owner").val($.trim($("#search-owner").val()));
                    $("#hidden-source").val($.trim($("#search-source").val()));
                    $("#hidden-contactsId").val($.trim($("#search-contactsId").val()));
                    pageList(1, 2);

                }

            })

            $("#qx").click(function () {

                $("input[name=xz]").prop("checked", this.checked);

            })

            $("#searchBtn").click(function () {

                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-customerId").val($.trim($("#search-customerId").val()));
                $("#hidden-stage").val($.trim($("#search-stage").val()));
                $("#hidden-type").val($.trim($("#search-type").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-source").val($.trim($("#search-source").val()));
                $("#hidden-contactsId").val($.trim($("#search-contactsId").val()));

                pageList(1, 2);

            })



        });


        function pageList(pageNo, pageSize) {

            //将全选的复选框的√干掉
            $("#qx").prop("checked", false);

            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-customerId").val($.trim($("#hidden-customerId").val()));
            $("#search-stage").val($.trim($("#hidden-stage").val()));
            $("#search-type").val($.trim($("#hidden-type").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-source").val($.trim($("#hidden-source").val()));
            $("#search-contactsId").val($.trim($("#hidden-contactsId").val()));


            $.ajax({

                url: "workbench/transaction/pageList.do",
                data: {

                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "customerId": $.trim($("#search-customerId").val()),
                    "stage": $.trim($("#search-stage").val()),
                    "type": $.trim($("#search-type").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "source": $.trim($("#search-source").val()),
                    "contactsId": $.trim($("#search-contactsId").val())


                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    /*

                        data

                            我们需要的：市场活动信息列表
                            [{市场活动1},{2},{3}] List<Activity> aList
                            一会分页插件需要的：查询出来的总记录数
                            {"total":100} int total

                            {"total":100,"dataList":[{市场活动1},{2},{3}]}

                     */

                    var html = "";
                    /*

                                <tr class="active">
                                                <td><input type="checkbox" /></td>
                                                <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">大工合-交易01</a></td>
                                                <td>大工合</td>
                                                <td>谈判/复审</td>
                                                <td>新业务</td>
                                                <td>zhangsan</td>
                                                <td>广告</td>
                                                <td>李四</td>
                                            </tr>

                            */
                    //每一个n就是每一个市场活动对象
                    $.each(data.dataList, function (i, n) {

                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.customerId + '</td>';
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.type + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.contactsId + '</td>';
                        html += '</tr>';

                    })

                    $("#activityBody").html(html);


                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    //数据处理完毕后，结合分页查询，对前端展现分页信息
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

                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });


                }

            })

        }

    </script>
</head>
<body>

<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-customerId"/>
<input type="hidden" id="hidden-stage"/>
<input type="hidden" id="hidden-type"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-contactsId"/>


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
                        <input class="form-control" type="text" id="search-customerId">
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
                                <option value="${t.value}}">${t.text}</option>
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
                        <input class="form-control" type="text" id="search-contactsId">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/add.do';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.html';"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?id=bb9a3804545c4658b1b5bf3e1f9acdd4';">交易</a></td>
                    <td>大工合</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">大工合-交易01</a></td>
                    <td>大工合</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
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