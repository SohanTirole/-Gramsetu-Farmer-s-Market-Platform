<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>GramSetu — ${pageTitle != null ? pageTitle : 'Rural Empowerment Platform'}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>

<nav class="navbar">
  <div class="container">
    <div class="navbar-inner">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
        <span class="leaf">&#127807;</span> Gram<span>Setu</span>
      </a>
      <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/crops/list">Marketplace</a>
        <a href="${pageContext.request.contextPath}/forum">Forum</a>
        <a href="${pageContext.request.contextPath}/schemes">Schemes</a>
        <a href="${pageContext.request.contextPath}/prices">Prices</a>
        <sec:authorize access="hasRole('FARMER')"><a href="${pageContext.request.contextPath}/farmer/dashboard">My Farm</a></sec:authorize>
        <sec:authorize access="hasRole('BUYER')"><a href="${pageContext.request.contextPath}/buyer/dashboard">My Orders</a></sec:authorize>
        <sec:authorize access="hasRole('SVC')"><a href="${pageContext.request.contextPath}/svc/dashboard">SVC Centre</a></sec:authorize>
        <sec:authorize access="hasRole('AGRONOMIST')"><a href="${pageContext.request.contextPath}/agro/dashboard">Advisory</a></sec:authorize>
        <sec:authorize access="hasRole('ADMIN')"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></sec:authorize>
      </div>
      <div class="nav-right">
        <sec:authorize access="isAuthenticated()">
          <sec:authentication property="principal.username" var="email"/>
          <div class="nav-avatar" title="${email}">${email.substring(0,1).toUpperCase()}</div>
          <c:if test="${unread != null && unread > 0}"><span class="nav-badge">${unread}</span></c:if>
          <form action="${pageContext.request.contextPath}/auth/logout" method="post" style="margin:0">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn-logout">Logout</button>
          </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
          <a href="${pageContext.request.contextPath}/auth/login"    class="btn btn-sm btn-outline-white">Login</a>
          <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-sm btn-terra">Register Free</a>
        </sec:authorize>
      </div>
    </div>
  </div>
</nav>

<main class="page-wrap"><div class="container">
<c:if test="${not empty successMsg}"><div class="alert alert-success"><span class="alert-icon">&#10003;</span>${successMsg}</div></c:if>
<c:if test="${not empty errorMsg}">  <div class="alert alert-error">  <span class="alert-icon">&#9888;</span>${errorMsg}</div></c:if>
<c:if test="${not empty warningMsg}"><div class="alert alert-warning"><span class="alert-icon">&#9888;</span>${warningMsg}</div></c:if>
