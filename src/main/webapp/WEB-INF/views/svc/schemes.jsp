<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Apply Schemes"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">SVC Centre</p>
  <a href="${pageContext.request.contextPath}/svc/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/svc/farmers"><span class="sidebar-icon">&#128101;</span>My Farmers</a>
  <a href="${pageContext.request.contextPath}/svc/list-crop"><span class="sidebar-icon">&#127807;</span>List Crop</a>
  <a href="${pageContext.request.contextPath}/svc/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/svc/schemes" class="active"><span class="sidebar-icon">&#128196;</span>Scheme Apply</a>
  <a href="${pageContext.request.contextPath}/svc/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Apply Scheme for Farmer</h1></div></div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">+ New Application</span></div>
    <form action="${pageContext.request.contextPath}/svc/scheme-apply/submit" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Select Farmer *</label>
          <select name="farmerId" class="form-control" required>
            <option value="">— Farmer —</option>
            <c:forEach var="f" items="${farmers}"><option value="${f.id}">${f.name} — ${f.village}</option></c:forEach>
          </select></div>
        <div class="form-group"><label class="form-label">Select Scheme *</label>
          <select name="schemeId" class="form-control" required>
            <option value="">— Scheme —</option>
            <c:forEach var="s" items="${schemes}"><option value="${s.id}">${s.scheme_name}</option></c:forEach>
          </select></div>
      </div>
      <button type="submit" class="btn btn-primary">Submit Application</button>
    </form>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">Applications Submitted</span></div>
    <c:choose>
      <c:when test="${empty applications}"><div class="empty-state"><div class="empty-icon">&#128196;</div><h3>No applications yet</h3></div></c:when>
      <c:otherwise><div class="table-wrap"><table class="gs-table">
        <thead><tr><th>Farmer</th><th>Scheme</th><th>Applied</th><th>Status</th></tr></thead>
        <tbody>
          <c:forEach var="a" items="${applications}">
            <tr>
              <td>${a.farmer_name}</td><td>${a.scheme_name}</td>
              <td><small>${a.applied_at}</small></td>
              <td><c:choose>
                <c:when test="${a.status=='APPROVED'}"><span class="badge badge-success">${a.status}</span></c:when>
                <c:when test="${a.status=='REJECTED'}"><span class="badge badge-danger">${a.status}</span></c:when>
                <c:otherwise><span class="badge badge-warning">${a.status}</span></c:otherwise>
              </c:choose></td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div></c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>