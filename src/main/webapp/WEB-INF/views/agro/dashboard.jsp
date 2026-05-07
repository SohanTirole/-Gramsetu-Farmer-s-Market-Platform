<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Agronomist Dashboard"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Expert Panel</p>
  <a href="${pageContext.request.contextPath}/agro/dashboard" class="active"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/agro/advisories"><span class="sidebar-icon">&#129526;</span>Soil Advisories</a>
  <a href="${pageContext.request.contextPath}/forum"><span class="sidebar-icon">&#128172;</span>Forum</a>
  <a href="${pageContext.request.contextPath}/agro/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Agronomist Dashboard</h1><p>${agro.name} &bull; Expert Advisor</p></div><a href="${pageContext.request.contextPath}/agro/advisories" class="btn btn-primary">View All Requests</a></div>
  <div class="stats-grid">
    <div class="stat-card terra"><div class="stat-val">${pendingCount}</div><div class="stat-label">Pending Advisories</div></div>
    <div class="stat-card"><div class="stat-val">${completedCount}</div><div class="stat-label">Completed</div></div>
    <div class="stat-card gold"><div class="stat-val">${unread}</div><div class="stat-label">Notifications</div></div>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">&#129526; Pending Soil Advisory Requests</span></div>
    <c:choose>
      <c:when test="${empty pendingAdvisories}"><p class="text-muted text-center" style="padding:24px">No pending requests. All caught up!</p></c:when>
      <c:otherwise>
        <div class="table-wrap"><table class="gs-table">
          <thead><tr><th>Farmer</th><th>Village</th><th>Description</th><th>Submitted</th><th>Action</th></tr></thead>
          <tbody>
            <c:forEach var="a" items="${pendingAdvisories}">
              <tr>
                <td><strong>${a.farmer_name}</strong></td><td>${a.farmer_village}</td>
                <td>${a.soil_description.length() > 70 ? a.soil_description.substring(0,70).concat('...') : a.soil_description}</td>
                <td><small>${a.submitted_at}</small></td>
                <td><a href="${pageContext.request.contextPath}/agro/advisories" class="btn btn-primary btn-sm">Respond</a></td>
              </tr>
            </c:forEach>
          </tbody>
        </table></div>
      </c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>