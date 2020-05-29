<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2020/5/20
  Time: 17:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>主页面</title>
    <style type="text/css">
        .content {
            width: 950px;
        }

        #All:hover {
            cursor: pointer;
        }

        .content table input {
            width: 15px;
            height: 15px;
        }
        .pagination li{
            list-style-type: none;
            float: left;
            padding: 10px;
        }
    </style>
    <%--提交表单的方法--%>
    <script>
        /*获取你要查看的页码，并且放到表单隐藏域里面*/
        function subPage(page) {
            document.getElementById("pageNum").value=page;
            subFrom();
        }
        function subFrom(){
            document.getElementById("queryFor").setAttribute("action","/customerController/findForSearch")
            document.getElementById("queryFor").submit();
        }
        function add(id) {
            window.location.href="/customerController/toAdd";
        }
        /*全选的方法*/
        function qx() {
            //拿到里面的文字
            var text=document.getElementById("All").innerHTML;
            if (text=="全选"){
                //拿到所有的多选框
                var a=document.getElementsByName("selectCustomerId");
                for (var i=0;i<a.length;i++){
                    a[i].checked=true;
                }
                document.getElementById("All").innerHTML="取消";
            } else if (text=="取消") {
                var a=document.getElementsByName("selectCustomerId");
                for (var i=0;i<a.length;i++){
                    a[i].checked=false;
                }
                document.getElementById("All").innerHTML="全选";
            }
        }
        /*删除*/
        function del() {
            //获取选中的多选框
            var b=[];
            //获取选中的所有多选框
            var a=document.getElementsByName("selectCustomerId");
            for (var i=0;i<a.length;i++){
                if (a[i].checked==true){
                    b.push(a[i]);
                }
            }
            if (b.length<=0){
                alert("请选择你要删除的数据")
            } else{
                if (confirm("你确认删除吗？")) {
                    //到删除的方法
                    document.getElementById("queryFor").setAttribute("action","/customerController/doDelete");
                    document.getElementById("queryFor").submit();
                }
            }
        }

        /*修改*/
        function up(){
            //获取选中的多选框
            var count=0;//多选框选中的个数
            //1.拿到说有的多选框
            var a=document.getElementsByName("selectCustomerId");
            for (var i=0;i<a.length;i++){
                if (a[i].checked==true){
                    count++;
                }
            }
            //2.判断
            if (count>1){
                alert("只能选择一条数据进行修改");
            } else if (count<1){
                alert("请选择你要修改的值");
            } else {
                //正常情况可到达去修改页面的controller
                document.getElementById("queryFor").setAttribute("action","/customerController/toUpdate");
                document.getElementById("queryFor").submit();

            }
        }
    </script>

</head>
<body>
<h1>客户信息列表</h1>
<div class="content">
    <form:form modelAttribute="customer" method="post" id="queryFor">
        <%--传页码--%>
        <input type="hidden" name="pageNum" id="pageNum">
        <div>
            <button id="queryBtn" onclick="subPage(1)">查询</button>
            <input type="button" id="addBtn" onclick="add()" value="新增"/>
            <input id="updateBtn" type="button" onclick="up()" value="修改"></input>
            <input id="deleteBtn" type="button" onclick="del()" value="删除"></input>
        </div>
        <br><br>
        <div>
            <span>客户编号</span>
            <c:if test="${customerId}!=0">
                <form:input path="customerId"></form:input>
            </c:if>
            <input type="text" id="customerId" name="customerId">
            <span>客户名称</span>
            <form:input path="customerName" ></form:input><br><br>
            <span>客户信息来源</span>
            <form:select path="customerSourse">
                <form:option value="">请选择</form:option>
                <form:option value="A">电话营销</form:option>
                <form:option value="B">网络营销</form:option>
            </form:select>
            <span>创建日期</span>
            <input type="text" id="customerDateBegin" name="customerDateBegin" value="${customerDateBegin}">
            <input type="text" id="customerDateEnd" name="customerDateEnd" value="${customerDateEnd}">
        </div>
        <br><br>
        <table border="1px" cellpadding="5" cellspacing="0">
            <tr>
                <td width="5%" align="center" id="All" onclick="qx()">全选</td>
                <td width="15%" align="center">客户编号</td>
                <td width="15%" align="center">客户名称</td>
                <td width="15%" align="center">客户负责人</td>
                <td width="18%" align="center">客户信息来源</td>
                <td width="18%" align="center">客户所属行业</td>
                <td wdth="23%" align="center">创建日期</td>
            </tr>
            <c:forEach var="c" items="${list}">
                <tr>
                    <td align="center"><input type="checkbox" name="selectCustomerId" value="${c.customerId}"></td>
                    <td align="center">${c.customerId}</td>
                    <td align="center">${c.customerName}</td>
                    <td align="center">${c.customerUserName}</td>
                    <td align="center">${c.customerSourseDict}</td>
                    <td align="center">${c.customerIndustryDict}</td>
                    <td align="center">${c.customerDate}</td>
                </tr>
            </c:forEach>
        </table>
        <br><br>
        <!--分页开始-->
        <div>
            共有${totalRows}条数据，共有${totalPage}页，当前为第${pageNum}页<br>
            <ul class="pagination">
                <%--上一页--%>
                    <c:if test="${pageNum>1}">
                        <li><a href="javascript:void(0)" onclick="subPage(${pageNum-1})"><<</a></li>
                    </c:if>
                    <c:if test="${pageNum==1}">
                        <li><<</li>
                    </c:if>

                <%--中间页--%>
                <c:choose>
                    <%--总页数小于5页--%>
                    <c:when test="${totalPage<=5}">
                        <c:set var="begin" value="1"/>
                        <c:set var="end" value="${totalPage}"/>
                    </c:when>
                    <%--总页数大于5页--%>
                    <c:otherwise>
                        <c:set var="begin" value="${pageNum-1}"/>
                        <c:set var="end" value="${pageNum+3}"/>
                        <%--如果当前是第一页，最大页为5--%>
                        <c:if test="${begin-1<=0}">
                            <c:set var="begin" value="1"/>
                            <c:set var="end" value="5"/>
                        </c:if>
                        <%--end大于最大页，设置begin等于最大页-4--%>
                        <c:if test="${end>totalPage}">
                            <c:set var="begin" value="${totalPage-4}"/>
                            <c:set var="end" value="${totalPage}"/>
                        </c:if>
                    </c:otherwise>
                </c:choose>
                <%--遍历显示中间页码--%>
                <c:forEach var="i" begin="${begin}" end="${end}">
                    <%--当前，选中--%>
                    <c:choose>
                        <c:when test="${i==pageNum}">
                            <li>${i}</li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="javascript:void(0)" onclick="subPage(${i})">${i}</a></li>
                        </c:otherwise>
                    </c:choose>
                   <%-- <li><a href="#">1</a></li>--%>
                </c:forEach>
                <%--下一页--%>
                <c:if test="${pageNum<totalPage}">
                    <li><a href="javascript:void(0)" onclick="subPage(${pageNum+1})">>></a></li>
                </c:if>
                <c:if test="${pageNum==totalPage}">
                    <li>>></li>
                </c:if>

            </ul>
        </div>

    </form:form>
</div>
</body>
</html>

