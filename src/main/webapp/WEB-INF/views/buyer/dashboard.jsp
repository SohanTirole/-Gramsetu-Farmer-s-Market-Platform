<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Buyer Dashboard"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Navigation</p>
  <a href="${pageContext.request.contextPath}/buyer/dashboard" class="active"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/crops/list"><span class="sidebar-icon">&#127807;</span>Marketplace</a>
  <a href="${pageContext.request.contextPath}/buyer/orders"><span class="sidebar-icon">&#128230;</span>My Orders</a>
  <a href="${pageContext.request.contextPath}/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/forum"><span class="sidebar-icon">&#128172;</span>Forum</a>
  <a href="${pageContext.request.contextPath}/buyer/notifications"><span class="sidebar-icon">&#128276;</span>Notifications <c:if test="${unread>0}"><span class="nav-badge">${unread}</span></c:if></a>
  <a href="${pageContext.request.contextPath}/buyer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Welcome, ${buyer.name}!</h1><p>${buyer.district}, ${buyer.state}</p></div><a href="${pageContext.request.contextPath}/crops/list" class="btn btn-primary">Browse Marketplace</a></div>
  <div class="stats-grid">
    <div class="stat-card"><div class="stat-val">${totalOrders}</div><div class="stat-label">Total Orders</div></div>
    <div class="stat-card terra"><div class="stat-val">${activeOrders}</div><div class="stat-label">Active Orders</div></div>
    <div class="stat-card gold"><div class="stat-val">${unread}</div><div class="stat-label">Notifications</div></div>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">&#128230; Recent Orders</span><a href="${pageContext.request.contextPath}/buyer/orders" class="btn btn-secondary btn-sm">View All</a></div>
    <c:choose>
      <c:when test="${empty recentOrders}"><div class="empty-state" style="padding:32px"><div class="empty-icon" style="font-size:40px">&#128230;</div><h3>No orders yet</h3><a href="${pageContext.request.contextPath}/crops/list" class="btn btn-primary btn-sm mt-2">Browse Marketplace</a></div></c:when>
      <c:otherwise>
        <div class="table-wrap"><table class="gs-table">
          <thead><tr><th>Order#</th><th>Crop</th><th>Farmer</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
          <tbody>
            <c:forEach var="o" items="${recentOrders}">
              <tr>
                <td><strong>#${o.id}</strong></td><td>${o.cropName}</td><td>${o.farmerName}</td>
                <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" pattern="#,##0.00"/></td>
                <td><c:choose><c:when test="${o.status=='DELIVERED'}"><span class="badge badge-green">${o.status}</span></c:when><c:when test="${o.status=='CANCELLED'}"><span class="badge badge-red">${o.status}</span></c:when><c:when test="${o.status=='PENDING'}"><span class="badge badge-amber">${o.status}</span></c:when><c:otherwise><span class="badge badge-blue">${o.status}</span></c:otherwise></c:choose></td>
                <td><a href="${pageContext.request.contextPath}/buyer/orders/detail/${o.id}" class="btn btn-secondary btn-sm">Details</a></td>
              </tr>
            </c:forEach>
          </tbody>
        </table></div>
      </c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>