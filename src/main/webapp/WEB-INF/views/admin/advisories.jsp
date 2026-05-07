<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Advisories — Admin"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops"><span class="sidebar-icon">&#127807;</span>Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories" class="active"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices"><span class="sidebar-icon">&#128200;</span>Prices</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>All Soil Advisories</h1></div></div>
  <div class="card"><div class="table-wrap"><table class="gs-table">
    <thead><tr><th>ID</th><th>Farmer</th><th>Description</th><th>Status</th><th>Submitted</th></tr></thead>
    <tbody>
      <c:forEach var="a" items="${advisories}">
        <tr>
          <td>${a.id}</td><td><strong>${a.farmer_name}</strong></td>
          <td>${a.soil_description.length() > 70 ? a.soil_description.substring(0,70).concat('...') : a.soil_description}</td>
          <td><c:choose>
            <c:when test="${a.status=='COMPLETED'}"><span class="badge badge-success">${a.status}</span></c:when>
            <c:when test="${a.status=='PENDING'}">  <span class="badge badge-warning">${a.status}</span></c:when>
            <c:otherwise>                           <span class="badge badge-info">${a.status}</span></c:otherwise>
          </c:choose></td>
          <td><small>${a.submitted_at}</small></td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div></div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>