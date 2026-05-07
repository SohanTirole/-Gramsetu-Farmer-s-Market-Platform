<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Farmers"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">SVC Centre</p>
  <a href="${pageContext.request.contextPath}/svc/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/svc/register-farmer"><span class="sidebar-icon">&#43;</span>Register Farmer</a>
  <a href="${pageContext.request.contextPath}/svc/farmers" class="active"><span class="sidebar-icon">&#128101;</span>My Farmers</a>
  <a href="${pageContext.request.contextPath}/svc/list-crop"><span class="sidebar-icon">&#127807;</span>List Crop</a>
  <a href="${pageContext.request.contextPath}/svc/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/svc/schemes"><span class="sidebar-icon">&#128196;</span>Scheme Apply</a>
  <a href="${pageContext.request.contextPath}/svc/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>My Farmers</h1><p>All farmers in your cluster</p></div>
    <a href="${pageContext.request.contextPath}/svc/register-farmer" class="btn btn-primary">+ Register Farmer</a></div>
  <c:choose>
    <c:when test="${empty farmers}">
      <div class="card"><div class="empty-state"><div class="empty-icon">&#128101;</div>
        <h3>No farmers registered yet</h3><p>Register farmers from your village cluster to get started.</p>
        <a href="${pageContext.request.contextPath}/svc/register-farmer" class="btn btn-primary">Register First Farmer</a>
      </div></div>
    </c:when>
    <c:otherwise>
      <div class="card"><div class="table-wrap"><table class="gs-table">
        <thead><tr><th>Name</th><th>Phone</th><th>Village</th><th>District</th><th>Actions</th></tr></thead>
        <tbody>
          <c:forEach var="f" items="${farmers}">
            <tr>
              <td><strong>${f.name}</strong></td><td>${f.phone}</td>
              <td>${f.village}</td><td>${f.district}, ${f.state}</td>
              <td>
                <a href="${pageContext.request.contextPath}/svc/list-crop?farmerId=${f.id}" class="btn btn-sm btn-primary">+ List Crop</a>
                <a href="${pageContext.request.contextPath}/svc/soil-advisory?farmerId=${f.id}" class="btn btn-sm btn-outline">Soil Advisory</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div></div>
    </c:otherwise>
  </c:choose>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>