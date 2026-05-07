<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="SVC Agents — Admin"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops"><span class="sidebar-icon">&#127807;</span>Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices"><span class="sidebar-icon">&#128200;</span>Prices</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents" class="active"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header">
    <div><h1>SVC Agents</h1><p>Smart Village Centre operators</p></div>
    <button onclick="document.getElementById('regForm').style.display='block'" class="btn btn-primary">+ Register SVC</button>
  </div>
  <div class="card mb-3" id="regForm" style="display:none">
    <div class="card-header"><span class="card-title">Register New SVC Agent</span></div>
    <form action="${pageContext.request.contextPath}/admin/svc-agents/register" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Select User (Role: SVC) *</label>
          <select name="userId" class="form-control" required>
            <option value="">— Select User —</option>
            <c:forEach var="u" items="${svcUsers}"><option value="${u.id}">${u.name} — ${u.email}</option></c:forEach>
          </select></div>
        <div class="form-group"><label class="form-label">Centre Name *</label><input type="text" name="centreName" class="form-control" required></div>
      </div>
      <div class="form-group"><label class="form-label">Villages Covered (comma-separated)</label>
        <input type="text" name="villagesCovered" class="form-control" placeholder="Rampur, Shivpuri, Gaonkhed"></div>
      <button type="submit" class="btn btn-primary">Register SVC</button>
    </form>
  </div>
  <div class="card"><div class="table-wrap"><table class="gs-table">
    <thead><tr><th>Agent</th><th>Centre</th><th>Villages</th><th>Farmers</th><th>Commission</th><th>State</th></tr></thead>
    <tbody>
      <c:forEach var="a" items="${agents}">
        <tr>
          <td><strong>${a.agent_name}</strong><br><small class="text-muted">${a.email}</small></td>
          <td>${a.centre_name}</td>
          <td style="font-size:12px">${a.villages_covered}</td>
          <td>${a.farmers_registered}</td>
          <td>&#8377;<fmt:formatNumber value="${a.commission_earned}" pattern="#,##0.00"/></td>
          <td>${a.state}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div></div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>