<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="All Crops — Admin"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops" class="active"><span class="sidebar-icon">&#127807;</span>Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices"><span class="sidebar-icon">&#128200;</span>Prices</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>All Crops</h1></div></div>
  <div class="card"><div class="table-wrap"><table class="gs-table">
    <thead><tr><th>ID</th><th>Crop</th><th>Category</th><th>Farmer</th><th>State</th><th>Qty</th><th>Price</th><th>Status</th></tr></thead>
    <tbody>
      <c:forEach var="c" items="${crops}">
        <tr>
          <td>${c.id}</td><td><strong>${c.name}</strong></td>
          <td><span class="badge badge-info">${c.category}</span></td>
          <td>${c.farmerName}</td><td>${c.state}</td>
          <td>${c.quantity} ${c.unit}</td><td>&#8377;${c.pricePerUnit}</td>
          <td><c:choose>
            <c:when test="${c.available}"><span class="badge badge-success">Available</span></c:when>
            <c:otherwise><span class="badge badge-danger">Sold Out</span></c:otherwise>
          </c:choose></td>
        </tr>
      </c:forEach>
    </tbody>
  </table></div></div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>