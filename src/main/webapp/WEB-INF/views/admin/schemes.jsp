<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Schemes — Admin"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops"><span class="sidebar-icon">&#127807;</span>Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes" class="active"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices"><span class="sidebar-icon">&#128200;</span>Prices</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Government Schemes</h1></div>
    <button onclick="document.getElementById('addForm').style.display='block'" class="btn btn-primary">+ Add Scheme</button></div>
  <div class="card mb-3" id="addForm" style="display:none">
    <div class="card-header"><span class="card-title">Add New Scheme</span></div>
    <form action="${pageContext.request.contextPath}/admin/schemes/add" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Scheme Name *</label><input type="text" name="schemeName" class="form-control" required></div>
        <div class="form-group"><label class="form-label">Ministry *</label><input type="text" name="ministry" class="form-control" required></div>
      </div>
      <div class="form-group"><label class="form-label">Description *</label><textarea name="description" class="form-control" rows="2" required></textarea></div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Eligibility</label><textarea name="eligibility" class="form-control" rows="2"></textarea></div>
        <div class="form-group"><label class="form-label">Benefits</label><textarea name="benefits" class="form-control" rows="2"></textarea></div>
      </div>
      <div class="form-group"><label class="form-label">Apply URL</label><input type="url" name="applyUrl" class="form-control"></div>
      <button type="submit" class="btn btn-primary">Add Scheme</button>
    </form>
  </div>
  <div class="card"><div class="table-wrap"><table class="gs-table">
    <thead><tr><th>Scheme</th><th>Ministry</th><th>Status</th><th>Action</th></tr></thead>
    <tbody>
      <c:forEach var="s" items="${schemes}">
        <tr>
          <td><strong>${s.scheme_name}</strong><br><small class="text-muted">${s.benefits}</small></td>
          <td>${s.ministry}</td>
          <td><c:choose>
            <c:when test="${s.is_active}"><span class="badge badge-success">Active</span></c:when>
            <c:otherwise><span class="badge badge-danger">Inactive</span></c:otherwise>
          </c:choose></td>
          <td>
            <form action="${pageContext.request.contextPath}/admin/schemes/toggle/${s.id}" method="post" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <button type="submit" class="btn btn-sm btn-outline">Toggle</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div></div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>