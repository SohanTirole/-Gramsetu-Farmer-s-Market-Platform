<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="SVC Dashboard"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">SVC Centre</p>
  <a href="${pageContext.request.contextPath}/svc/dashboard" class="active"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/svc/register-farmer"><span class="sidebar-icon">&#43;</span>Register Farmer</a>
  <a href="${pageContext.request.contextPath}/svc/farmers"><span class="sidebar-icon">&#128101;</span>My Farmers</a>
  <a href="${pageContext.request.contextPath}/svc/list-crop"><span class="sidebar-icon">&#127807;</span>List Crop</a>
  <a href="${pageContext.request.contextPath}/svc/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/svc/scheme-apply"><span class="sidebar-icon">&#128196;</span>Apply Scheme</a>
  <a href="${pageContext.request.contextPath}/svc/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header">
    <div><h1>SVC Dashboard</h1><p>${svc.name} &bull; <c:if test="${not empty agentInfo}">${agentInfo.centre_name}</c:if></p></div>
    <a href="${pageContext.request.contextPath}/svc/register-farmer" class="btn btn-primary">+ Register Farmer</a>
  </div>
  <div class="stats-grid">
    <div class="stat-card"><div class="stat-val"><c:if test="${not empty agentInfo}">${agentInfo.farmers_registered}</c:if><c:if test="${empty agentInfo}">0</c:if></div><div class="stat-label">Farmers Registered</div></div>
    <div class="stat-card terra"><div class="stat-val">${cropCount != null ? cropCount : 0}</div><div class="stat-label">Crops Listed</div></div>
    <div class="stat-card gold"><div class="stat-val">&#8377;<c:if test="${not empty agentInfo}"><fmt:formatNumber value="${agentInfo.commission_earned}" pattern="#,##0"/></c:if><c:if test="${empty agentInfo}">0</c:if></div><div class="stat-label">Commission Earned</div></div>
    <div class="stat-card blue"><div class="stat-val">${schemeCount != null ? schemeCount : 0}</div><div class="stat-label">Schemes Applied</div></div>
  </div>
  <c:if test="${not empty agentInfo && not empty agentInfo.villages_covered}">
    <div class="card mb-3">
      <div class="card-header"><span class="card-title">&#127968; Villages Covered</span></div>
      <div style="display:flex;flex-wrap:wrap;gap:8px;padding:4px 0">
        <c:forTokens items="${agentInfo.villages_covered}" delims="," var="village">
          <span class="badge badge-green" style="padding:5px 12px">${village.trim()}</span>
        </c:forTokens>
      </div>
    </div>
  </c:if>
  <div class="card">
    <div class="card-header"><span class="card-title">&#127807; Recent Crops Listed by You</span><a href="${pageContext.request.contextPath}/svc/list-crop" class="btn btn-primary btn-sm">+ List Crop</a></div>
    <c:choose>
      <c:when test="${empty recentCrops}"><p class="text-muted text-center" style="padding:20px">No crops listed yet. List crops on behalf of farmers.</p></c:when>
      <c:otherwise>
        <div class="table-wrap"><table class="gs-table">
          <thead><tr><th>Crop</th><th>Farmer</th><th>Qty</th><th>Price</th><th>Status</th></tr></thead>
          <tbody>
            <c:forEach var="c" items="${recentCrops}">
              <tr>
                <td><strong>${c.name}</strong></td><td>${c.farmer_name}</td>
                <td>${c.quantity} ${c.unit}</td><td>&#8377;${c.price_per_unit}</td>
                <td><c:choose><c:when test="${c.is_available==1}"><span class="badge badge-green">Available</span></c:when><c:otherwise><span class="badge badge-red">Sold Out</span></c:otherwise></c:choose></td>
              </tr>
            </c:forEach>
          </tbody>
        </table></div>
      </c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>