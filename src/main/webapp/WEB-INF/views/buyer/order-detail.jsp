<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Order Details"/>
<div class="page-header">
  <div><h1>Order #${order.id}</h1><p>Order details and tracking</p></div>
  <a href="${pageContext.request.contextPath}/buyer/orders" class="btn btn-outline">&#8592; My Orders</a>
</div>
<div style="display:grid;grid-template-columns:2fr 1fr;gap:22px">
  <div>
    <div class="card mb-3">
      <div class="card-header"><span class="card-title">Order Summary</span></div>
      <table class="gs-table">
        <tr><td class="text-muted" style="width:150px">Crop</td>     <td><strong>${order.cropName}</strong></td></tr>
        <tr><td class="text-muted">Farmer</td>    <td>${order.farmerName} &bull; ${order.farmerPhone}</td></tr>
        <tr><td class="text-muted">Quantity</td>  <td>${order.quantity}</td></tr>
        <tr><td class="text-muted">Total</td>     <td><strong>&#8377;<fmt:formatNumber value="${order.totalPrice}" pattern="#,##0.00"/></strong></td></tr>
        <tr><td class="text-muted">Payment</td>   <td>
          <c:choose>
            <c:when test="${order.paymentStatus=='PAID'}">  <span class="badge badge-success">PAID</span></c:when>
            <c:when test="${order.paymentStatus=='UNPAID'}"><span class="badge badge-warning">UNPAID</span></c:when>
            <c:otherwise>                                   <span class="badge badge-info">${order.paymentStatus}</span></c:otherwise>
          </c:choose> via ${order.paymentMethod}</td></tr>
        <tr><td class="text-muted">Status</td>    <td>
          <c:choose>
            <c:when test="${order.status=='DELIVERED'}"><span class="badge badge-success">${order.status}</span></c:when>
            <c:when test="${order.status=='CANCELLED'}"><span class="badge badge-danger">${order.status}</span></c:when>
            <c:when test="${order.status=='PENDING'}">  <span class="badge badge-warning">${order.status}</span></c:when>
            <c:otherwise>                               <span class="badge badge-info">${order.status}</span></c:otherwise>
          </c:choose></td></tr>
        <tr><td class="text-muted">Address</td>   <td>${order.deliveryAddress}</td></tr>
        <tr><td class="text-muted">Ordered</td>   <td>${order.orderedAt}</td></tr>
      </table>
    </div>
    <div class="card">
      <div class="card-header"><span class="card-title">&#128666; Delivery Tracking</span></div>
      <c:choose>
        <c:when test="${empty logistics}">
          <p class="text-muted" style="padding:16px">Logistics details will appear once the order is dispatched.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="lg" items="${logistics}">
            <table class="gs-table">
              <tr><td class="text-muted">Transporter</td><td>${lg.transporter_name}</td></tr>
              <tr><td class="text-muted">Vehicle</td>    <td>${lg.vehicle_number}</td></tr>
              <tr><td class="text-muted">Expected</td>   <td>${lg.expected_delivery}</td></tr>
              <tr><td class="text-muted">Status</td>     <td><span class="badge badge-info">${lg.current_status}</span></td></tr>
            </table>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
  <div>
    <div class="card mb-3">
      <div class="card-header"><span class="card-title">Order Timeline</span></div>
      <div class="timeline">
        <c:set var="statuses" value="${['PENDING','CONFIRMED','PACKED','DISPATCHED','DELIVERED']}"/>
        <c:set var="reached" value="false"/>
        <c:forEach var="st" items="${statuses}">
          <c:set var="isActive" value="${order.status == st}"/>
          <c:set var="isDone" value="${!isActive && !reached}"/>
          <div class="timeline-step">
            <div class="timeline-dot ${isActive ? 'active' : (isDone ? 'done' : 'pending')}">
              ${isDone ? '&#10003;' : (isActive ? '&#9679;' : '&#9675;')}
            </div>
            <span class="timeline-label ${isActive ? 'active' : ''}">${st}</span>
          </div>
          <c:if test="${isActive}"><c:set var="reached" value="true"/></c:if>
        </c:forEach>
      </div>
    </div>
    <div class="card">
      <div class="card-header"><span class="card-title">Actions</span></div>
      <c:if test="${order.status=='PENDING'}">
        <a href="${pageContext.request.contextPath}/buyer/orders/cancel/${order.id}"
           class="btn btn-danger w-full mb-2" onclick="return confirm('Cancel this order?')">Cancel Order</a>
      </c:if>
      <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-primary w-full">Order Again</a>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>