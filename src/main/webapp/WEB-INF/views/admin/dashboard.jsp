<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Admin Dashboard"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin Panel</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard" class="active"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops"><span class="sidebar-icon">&#127807;</span>All Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders"><span class="sidebar-icon">&#128230;</span>All Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices"><span class="sidebar-icon">&#128200;</span>Price History</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Admin Dashboard</h1><p>GramSetu platform overview</p></div></div>
  <div class="stats-grid">
    <div class="stat-card"><div class="stat-val">${totalFarmers}</div><div class="stat-label">Farmers</div></div>
    <div class="stat-card terra"><div class="stat-val">${totalBuyers}</div><div class="stat-label">Buyers</div></div>
    <div class="stat-card gold"><div class="stat-val">${totalSvc}</div><div class="stat-label">SVC Agents</div></div>
    <div class="stat-card blue"><div class="stat-val">${totalCrops}</div><div class="stat-label">Crops Listed</div></div>
    <div class="stat-card"><div class="stat-val">${totalOrders}</div><div class="stat-label">Total Orders</div></div>
    <div class="stat-card terra"><div class="stat-val">${pendingAdvisory}</div><div class="stat-label">Pending Advisory</div></div>
  </div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">&#128101; Recently Registered Users</span><a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">All Users</a></div>
    <div class="table-wrap"><table class="gs-table">
      <thead><tr><th>Name</th><th>Email</th><th>Role</th><th>State</th><th>Status</th><th>Action</th></tr></thead>
      <tbody>
        <c:forEach var="u" items="${recentUsers}">
          <tr>
            <td><strong>${u.name}</strong></td><td>${u.email}</td>
            <td><c:choose><c:when test="${u.role=='ROLE_FARMER'}"><span class="badge badge-green">FARMER</span></c:when><c:when test="${u.role=='ROLE_BUYER'}"><span class="badge badge-blue">BUYER</span></c:when><c:when test="${u.role=='ROLE_SVC'}"><span class="badge badge-purple">SVC</span></c:when><c:when test="${u.role=='ROLE_AGRONOMIST'}"><span class="badge badge-amber">AGRONOMIST</span></c:when><c:otherwise><span class="badge badge-gray">${u.role}</span></c:otherwise></c:choose></td>
            <td>${u.state}</td>
            <td><c:choose><c:when test="${u.is_active==1}"><span class="badge badge-green">Active</span></c:when><c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise></c:choose></td>
            <td>
              <form action="${pageContext.request.contextPath}/admin/users/deactivate/${u.id}" method="post" style="display:inline"
                    onsubmit="return confirm('Deactivate this user?')">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-danger btn-sm">Deactivate</button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table></div>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">&#128290; Broadcast Notification</span></div>
    <form action="${pageContext.request.contextPath}/admin/notify/broadcast" method="post" style="display:flex;gap:12px;flex-wrap:wrap">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <select name="role" class="form-control" style="max-width:180px">
        <option value="FARMER">All Farmers</option><option value="BUYER">All Buyers</option><option value="SVC">All SVC Agents</option>
      </select>
      <input type="text" name="message" class="form-control" placeholder="Notification message..." style="flex:1;min-width:200px" required>
      <button type="submit" class="btn btn-primary">Send</button>
    </form>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>