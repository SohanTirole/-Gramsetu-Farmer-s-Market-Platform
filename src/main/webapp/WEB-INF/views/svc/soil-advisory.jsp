<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Soil Advisory"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">SVC Centre</p>
  <a href="${pageContext.request.contextPath}/svc/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/svc/farmers"><span class="sidebar-icon">&#128101;</span>My Farmers</a>
  <a href="${pageContext.request.contextPath}/svc/list-crop"><span class="sidebar-icon">&#127807;</span>List Crop</a>
  <a href="${pageContext.request.contextPath}/svc/soil-advisory" class="active"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/svc/schemes"><span class="sidebar-icon">&#128196;</span>Scheme Apply</a>
  <a href="${pageContext.request.contextPath}/svc/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Soil Advisory</h1><p>Submit soil requests on behalf of farmers</p></div></div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">+ New Request</span></div>
    <form action="${pageContext.request.contextPath}/svc/soil-advisory/submit" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-group"><label class="form-label">Select Farmer *</label>
        <select name="farmerId" class="form-control" required>
          <option value="">— Select —</option>
          <c:forEach var="f" items="${farmers}"><option value="${f.id}" ${param.farmerId == f.id ? 'selected' : ''}>${f.name} — ${f.village}</option></c:forEach>
        </select></div>
      <div class="form-group"><label class="form-label">Soil Description *</label>
        <textarea name="soilDescription" class="form-control" rows="4" required></textarea></div>
      <div class="form-group"><label class="form-label">Soil Photo</label>
        <input type="file" name="photo" class="form-control" accept="image/*"></div>
      <button type="submit" class="btn btn-primary">Submit Request</button>
    </form>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">Past Requests</span></div>
    <c:choose>
      <c:when test="${empty advisories}"><div class="empty-state"><div class="empty-icon">&#129526;</div><h3>No requests yet</h3></div></c:when>
      <c:otherwise><div class="table-wrap"><table class="gs-table">
        <thead><tr><th>Farmer</th><th>Description</th><th>Status</th><th>Recommendation</th></tr></thead>
        <tbody>
          <c:forEach var="a" items="${advisories}">
            <tr>
              <td>${a.farmer_name}</td>
              <td>${a.soil_description.length() > 60 ? a.soil_description.substring(0,60).concat('...') : a.soil_description}</td>
              <td><c:choose>
                <c:when test="${a.status=='COMPLETED'}"><span class="badge badge-success">${a.status}</span></c:when>
                <c:when test="${a.status=='PENDING'}">  <span class="badge badge-warning">${a.status}</span></c:when>
                <c:otherwise>                           <span class="badge badge-info">${a.status}</span></c:otherwise>
              </c:choose></td>
              <td style="font-size:13px">${not empty a.recommendation ? a.recommendation.substring(0, [60, a.recommendation.length()].min()) : '—'}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div></c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>