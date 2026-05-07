<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Orders"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Buyer</p>
  <a href="${pageContext.request.contextPath}/buyer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/crops/list"><span class="sidebar-icon">&#127807;</span>Marketplace</a>
  <a href="${pageContext.request.contextPath}/buyer/orders" class="active"><span class="sidebar-icon">&#128230;</span>My Orders</a>
  <a href="${pageContext.request.contextPath}/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/forum"><span class="sidebar-icon">&#128172;</span>Forum</a>
  <a href="${pageContext.request.contextPath}/buyer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>My Orders</h1><p>Track all your purchases</p></div>
    <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-primary">Browse Marketplace</a></div>
  <c:choose>
    <c:when test="${empty orders}">
      <div class="card"><div class="empty-state"><div class="empty-icon">&#128230;</div>
        <h3>No orders yet</h3><p>Browse the marketplace and place your first order.</p>
        <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-primary">Go to Marketplace</a></div></div>
    </c:when>
    <c:otherwise>
      <div class="card"><div class="table-wrap"><table class="gs-table">
        <thead><tr><th>Order ID</th><th>Crop</th><th>Farmer</th><th>Qty</th><th>Amount</th><th>Payment</th><th>Status</th><th>Date</th><th>Action</th></tr></thead>
        <tbody>
          <c:forEach var="o" items="${orders}">
            <tr>
              <td><strong>#${o.id}</strong></td>
              <td>${o.cropName}</td>
              <td>${o.farmerName}<br><small class="text-muted">${o.farmerPhone}</small></td>
              <td>${o.quantity}</td>
              <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" pattern="#,##0.00"/></td>
              <td><c:choose>
                <c:when test="${o.paymentStatus=='PAID'}">  <span class="badge badge-success">PAID</span></c:when>
                <c:when test="${o.paymentStatus=='UNPAID'}"><span class="badge badge-warning">UNPAID</span></c:when>
                <c:otherwise>                              <span class="badge badge-info">${o.paymentStatus}</span></c:otherwise>
              </c:choose></td>
              <td><c:choose>
                <c:when test="${o.status=='DELIVERED'}"><span class="badge badge-success">${o.status}</span></c:when>
                <c:when test="${o.status=='CANCELLED'}"><span class="badge badge-danger">${o.status}</span></c:when>
                <c:when test="${o.status=='PENDING'}">  <span class="badge badge-warning">${o.status}</span></c:when>
                <c:otherwise>                           <span class="badge badge-info">${o.status}</span></c:otherwise>
              </c:choose></td>
              <td><small>${o.orderedAt}</small></td>
              <td>
                <a href="${pageContext.request.contextPath}/buyer/orders/detail/${o.id}" class="btn btn-sm btn-outline">Details</a>
                <c:if test="${o.status=='PENDING'}">
                  <form action="${pageContext.request.contextPath}/buyer/orders/cancel/${o.id}" method="post" style="display:inline"
                        onsubmit="return confirm('Cancel this order?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-sm btn-danger">Cancel</button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table></div></div>
    </c:otherwise>
  </c:choose>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>