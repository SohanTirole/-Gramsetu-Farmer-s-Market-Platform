<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Crops"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Farmer</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops" class="active"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/crops/add"><span class="sidebar-icon">&#43;</span>List New Crop</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/farmer/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/farmer/prices"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header">
    <div><h1>My Crops</h1><p>Manage all your listings</p></div>
    <a href="${pageContext.request.contextPath}/farmer/crops/add" class="btn btn-primary">+ List New Crop</a>
  </div>
  <c:choose>
    <c:when test="${empty crops}">
      <div class="card"><div class="empty-state">
        <div class="empty-icon">&#127807;</div>
        <h3>No crops listed yet</h3>
        <p>Start listing your crops to sell directly to buyers at fair prices.</p>
        <a href="${pageContext.request.contextPath}/farmer/crops/add" class="btn btn-primary">List Your First Crop</a>
      </div></div>
    </c:when>
    <c:otherwise>
      <div class="crop-grid">
        <c:forEach var="crop" items="${crops}">
          <div class="crop-card">
            <c:choose>
              <c:when test="${not empty crop.photoUrl}">
                <img class="crop-card-img" src="${pageContext.request.contextPath}${crop.photoUrl}" alt="${crop.name}">
              </c:when>
              <c:otherwise><div class="crop-card-placeholder">&#127807;</div></c:otherwise>
            </c:choose>
            <div class="crop-card-body">
              <div class="crop-card-head">
                <span class="crop-card-title">${crop.name}</span>
                <c:choose>
                  <c:when test="${crop.available}"><span class="badge badge-success">Available</span></c:when>
                  <c:otherwise><span class="badge badge-danger">Sold Out</span></c:otherwise>
                </c:choose>
              </div>
              <div class="crop-card-meta">${crop.quantity} ${crop.unit} &bull; <span class="badge badge-info">${crop.category}</span></div>
              <div class="crop-card-price">&#8377;${crop.pricePerUnit} <span>/ ${crop.unit}</span></div>
              <div style="display:flex;gap:8px;margin-top:10px">
                <a href="${pageContext.request.contextPath}/farmer/crops/edit/${crop.id}"
                   class="btn btn-sm btn-outline w-full">Edit</a>
                <form action="${pageContext.request.contextPath}/farmer/crops/delete/${crop.id}"
                      method="post" style="flex:1"
                      onsubmit="return confirm('Delete ${crop.name}?')">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                  <button type="submit" class="btn btn-sm btn-danger w-full">Delete</button>
                </form>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
