<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Orders Received"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Navigation</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/orders" class="active"><span class="sidebar-icon">&#128230;</span>Orders Received</a>
  <a href="${pageContext.request.contextPath}/farmer/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/farmer/prices"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>&#128230; Orders Received</h1><p>Manage buyer orders for your crops</p></div></div>
  <c:choose>
    <c:when test="${empty orders}">
      <div class="empty-state"><div class="empty-icon">&#128230;</div><h3>No orders yet</h3><p>Orders from buyers will appear here once placed.</p></div>
    </c:when>
    <c:otherwise>
      <div class="card"><div class="table-wrap"><table class="gs-table">
        <thead><tr><th>Order#</th><th>Crop</th><th>Buyer</th><th>Phone</th><th>Qty</th><th>Amount</th><th>Payment</th><th>Status</th><th>Action</th></tr></thead>
        <tbody>
          <c:forEach var="o" items="${orders}">
            <tr>
              <td><strong>#${o.id}</strong></td>
              <td>${o.cropName}</td>
              <td>${o.buyerName}</td>
              <td>${o.buyerPhone}</td>
              <td>${o.quantity}</td>
              <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" pattern="#,##0.00"/></td>
              <td>
                <c:choose>
                  <c:when test="${o.paymentStatus=='PAID'}"><span class="badge badge-green">PAID</span></c:when>
                  <c:otherwise><span class="badge badge-amber">${o.paymentStatus}</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${o.status=='DELIVERED'}"><span class="badge badge-green">${o.status}</span></c:when>
                  <c:when test="${o.status=='CANCELLED'}"><span class="badge badge-red">${o.status}</span></c:when>
                  <c:when test="${o.status=='PENDING'}">  <span class="badge badge-amber">${o.status}</span></c:when>
                  <c:otherwise>                           <span class="badge badge-blue">${o.status}</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <%-- Status update via POST form to prevent CSRF --%>
                <c:if test="${o.status=='PENDING'}">
                  <form action="${pageContext.request.contextPath}/farmer/orders/status/${o.id}" method="post" style="display:inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="CONFIRMED"/>
                    <button type="submit" class="btn btn-primary btn-sm">Confirm</button>
                  </form>
                </c:if>
                <c:if test="${o.status=='CONFIRMED'}">
                  <form action="${pageContext.request.contextPath}/farmer/orders/status/${o.id}" method="post" style="display:inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="PACKED"/>
                    <button type="submit" class="btn btn-secondary btn-sm">Packed</button>
                  </form>
                </c:if>
                <c:if test="${o.status=='PACKED'}">
                  <form action="${pageContext.request.contextPath}/farmer/orders/status/${o.id}" method="post" style="display:inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="DISPATCHED"/>
                    <button type="submit" class="btn btn-sm" style="background:var(--terra);color:white">Dispatch</button>
                  </form>
                </c:if>
                <c:if test="${o.status=='DISPATCHED'}">
                  <form action="${pageContext.request.contextPath}/farmer/orders/status/${o.id}" method="post" style="display:inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="DELIVERED"/>
                    <button type="submit" class="btn btn-primary btn-sm">Delivered</button>
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
