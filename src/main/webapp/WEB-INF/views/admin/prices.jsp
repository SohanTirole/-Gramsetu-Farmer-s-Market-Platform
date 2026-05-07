<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Price History — Admin"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops"><span class="sidebar-icon">&#127807;</span>Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices" class="active"><span class="sidebar-icon">&#128200;</span>Prices</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Price History</h1></div></div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">+ Add Price Entry</span></div>
    <form action="${pageContext.request.contextPath}/admin/prices/add" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Crop Name *</label><input type="text" name="cropName" class="form-control" required></div>
        <div class="form-group"><label class="form-label">State *</label><input type="text" name="state" class="form-control" required></div>
      </div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">MSP (&#8377;/Qtl) *</label><input type="number" name="mspPrice" class="form-control" step="0.01" required></div>
        <div class="form-group"><label class="form-label">Market Price (&#8377;/Qtl) *</label><input type="number" name="marketPrice" class="form-control" step="0.01" required></div>
      </div>
      <button type="submit" class="btn btn-primary">Add Entry</button>
    </form>
  </div>
  <div class="card"><div class="table-wrap"><table class="gs-table">
    <thead><tr><th>Crop</th><th>MSP</th><th>Market</th><th>State</th><th>Date</th></tr></thead>
    <tbody>
      <c:forEach var="p" items="${prices}">
        <tr>
          <td><strong>${p.crop_name}</strong></td>
          <td>&#8377;<fmt:formatNumber value="${p.msp_price}" pattern="#,##0"/></td>
          <td>&#8377;<fmt:formatNumber value="${p.market_price}" pattern="#,##0"/></td>
          <td>${p.state}</td><td>${p.recorded_date}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div></div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>