<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Farmer Dashboard"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Navigation</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard" class="active"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/crops/add"><span class="sidebar-icon">&#43;</span>List New Crop</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders Received</a>
  <a href="${pageContext.request.contextPath}/farmer/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/farmer/prices"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes"><span class="sidebar-icon">&#128196;</span>Govt Schemes</a>
  <a href="${pageContext.request.contextPath}/forum"><span class="sidebar-icon">&#128172;</span>Forum</a>
  <a href="${pageContext.request.contextPath}/farmer/notifications"><span class="sidebar-icon">&#128276;</span>Notifications <c:if test="${unread>0}"><span class="nav-badge">${unread}</span></c:if></a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header">
    <div><h1>Welcome back, ${farmer.name}!</h1><p>${farmer.village}, ${farmer.district}, ${farmer.state}</p></div>
    <a href="${pageContext.request.contextPath}/farmer/crops/add" class="btn btn-primary">+ List New Crop</a>
  </div>
  <div class="stats-grid">
    <div class="stat-card"><div class="stat-val">${cropCount}</div><div class="stat-label">Crops Listed</div></div>
    <div class="stat-card terra"><div class="stat-val">${orderCount}</div><div class="stat-label">Orders Received</div></div>
    <div class="stat-card gold"><div class="stat-val">${pendingOrders}</div><div class="stat-label">Pending Orders</div></div>
    <div class="stat-card blue"><div class="stat-val">${unread}</div><div class="stat-label">Notifications</div></div>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">&#127807; My Active Crops</span><a href="${pageContext.request.contextPath}/farmer/crops" class="btn btn-secondary btn-sm">View All</a></div>
    <c:choose>
      <c:when test="${empty crops}"><div class="empty-state" style="padding:32px"><div class="empty-icon" style="font-size:40px">&#127807;</div><h3>No crops listed yet</h3><p><a href="${pageContext.request.contextPath}/farmer/crops/add" class="btn btn-primary btn-sm mt-2">List Your First Crop</a></p></div></c:when>
      <c:otherwise>
        <div class="table-wrap"><table class="gs-table">
          <thead><tr><th>Crop</th><th>Category</th><th>Quantity</th><th>Price/Unit</th><th>Status</th><th>Actions</th></tr></thead>
          <tbody>
            <c:forEach var="crop" items="${crops}" varStatus="s"><c:if test="${s.index<5}">
              <tr>
                <td><strong>${crop.name}</strong></td>
                <td><span class="badge badge-green">${crop.category}</span></td>
                <td>${crop.quantity} ${crop.unit}</td>
                <td>&#8377;${crop.pricePerUnit}</td>
                <td><c:choose><c:when test="${crop.available}"><span class="badge badge-green">Available</span></c:when><c:otherwise><span class="badge badge-red">Sold Out</span></c:otherwise></c:choose></td>
                <td>
                  <a href="${pageContext.request.contextPath}/farmer/crops/edit/${crop.id}" class="btn btn-secondary btn-sm">Edit</a>
                  <a href="${pageContext.request.contextPath}/farmer/crops/delete/${crop.id}" class="btn btn-danger btn-sm" data-confirm="Delete this crop?">Delete</a>
                </td>
              </tr>
            </c:if></c:forEach>
          </tbody>
        </table></div>
      </c:otherwise>
    </c:choose>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">&#128230; Recent Orders</span><a href="${pageContext.request.contextPath}/farmer/orders" class="btn btn-secondary btn-sm">View All</a></div>
    <c:choose>
      <c:when test="${empty orders}"><p class="text-muted text-center" style="padding:20px">No orders received yet.</p></c:when>
      <c:otherwise>
        <div class="table-wrap"><table class="gs-table">
          <thead><tr><th>Order#</th><th>Crop</th><th>Buyer</th><th>Qty</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
          <tbody>
            <c:forEach var="o" items="${orders}" varStatus="s"><c:if test="${s.index<5}">
              <tr>
                <td>#${o.id}</td><td>${o.cropName}</td><td>${o.buyerName}</td><td>${o.quantity}</td>
                <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" pattern="#,##0.00"/></td>
                <td><c:choose><c:when test="${o.status=='DELIVERED'}"><span class="badge badge-green">${o.status}</span></c:when><c:when test="${o.status=='CANCELLED'}"><span class="badge badge-red">${o.status}</span></c:when><c:when test="${o.status=='PENDING'}"><span class="badge badge-amber">${o.status}</span></c:when><c:otherwise><span class="badge badge-blue">${o.status}</span></c:otherwise></c:choose></td>
                <td>
                  <c:if test="${o.status=='PENDING'}"><a href="${pageContext.request.contextPath}/farmer/orders/status/${o.id}?status=CONFIRMED" class="btn btn-primary btn-sm">Confirm</a></c:if>
                  <c:if test="${o.status=='CONFIRMED'}"><a href="${pageContext.request.contextPath}/farmer/orders/status/${o.id}?status=DISPATCHED" class="btn btn-terra btn-sm">Dispatch</a></c:if>
                </td>
              </tr>
            </c:if></c:forEach>
          </tbody>
        </table></div>
      </c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>