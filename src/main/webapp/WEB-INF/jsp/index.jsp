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
</head>
<body>
<h1>客户信息列表</h1>
<div class="content">
    <form:form modelAttribute="customer" action="" id="queryFor">
        <div>
            <button id="queryBtn">查询</button>
            <button id="addBtn">新增</button>
            <button id="updateBtn">修改</button>
            <button id="deleteBtn">删除</button>
        </div>
        <br><br>
        <div>
            <span>客户编号</span>
            <c:if test="${customerId}!=0">
                <form:input path="customerId"></form:input>
            </c:if>
            <input type="text" id="customerId" name="customerId">
            <span>客户名称</span>
            <form:input path="customerName"></form:input><br><br>
            <span>客户信息来源</span>
            <form:select path="customerSourse">
                <form:option value="">请选择</form:option>
                <form:option value="A">电话营销</form:option>
                <form:option value="B">网络营销</form:option>
            </form:select>
            <span>创建日期</span>
            <input type="text" id="customerDateBegin" name="customerDateBegin">
            <input type="text" id="customerDateEnd" name="customerDateEnd">
        </div>
        <br><br>
        <table border="1px" cellpadding="5" cellspacing="0">
            <tr>
                <td width="5%" align="center" id="All">全选</td>
                <td width="15%" align="center">客户编号</td>
                <td width="15%" align="center">客户名称</td>
                <td width="15%" align="center">客户负责人</td>
                <td width="18%" align="center">客户信息来源</td>
                <td width="18%" align="center">客户所属行业</td>
                <td wdth="23%" align="center">创建日期</td>
            </tr>
            <c:forEach var="c" items="${list}">
                <tr>
                    <td align="center"><input type="checkbox" name="selId"></td>
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
                    <li><a href="#"><<</a></li>
                </c:if>
                <c:if test="${pageNum}=1">
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
                            <li><a href="#">${i}</a></li>
                        </c:otherwise>
                    </c:choose>
                   <%-- <li><a href="#">1</a></li>--%>
                </c:forEach>
                <%--下一页--%>
                <c:if test="${pageNum<totalPage}">
                    <li><a href="#">>></a></li>
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

