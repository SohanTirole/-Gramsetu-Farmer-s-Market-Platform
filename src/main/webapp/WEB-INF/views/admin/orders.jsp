<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="All Orders — Admin"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Admin</p>
  <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users"><span class="sidebar-icon">&#128101;</span>Users</a>
  <a href="${pageContext.request.contextPath}/admin/crops"><span class="sidebar-icon">&#127807;</span>Crops</a>
  <a href="${pageContext.request.contextPath}/admin/orders" class="active"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/admin/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/admin/advisories"><span class="sidebar-icon">&#129526;</span>Advisories</a>
  <a href="${pageContext.request.contextPath}/admin/prices"><span class="sidebar-icon">&#128200;</span>Prices</a>
  <a href="${pageContext.request.contextPath}/admin/svc-agents"><span class="sidebar-icon">&#127968;</span>SVC Agents</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>All Orders</h1></div></div>
  <div class="card"><div class="table-wrap"><table class="gs-table">
    <thead><tr><th>ID</th><th>Crop</th><th>Buyer</th><th>Farmer</th><th>Qty</th><th>Amount</th><th>Payment</th><th>Status</th></tr></thead>
    <tbody>
      <c:forEach var="o" items="${orders}">
        <tr>
          <td>#${o.id}</td><td>${o.cropName}</td>
          <td>${o.buyerName}</td><td>${o.farmerName}</td>
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
        </tr>
      </c:forEach>
    </tbody>
  </table></div></div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>