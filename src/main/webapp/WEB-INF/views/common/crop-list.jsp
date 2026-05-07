<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Marketplace"/>
<div class="page-header">
  <div><h1>&#127807; Crop Marketplace</h1><p>Buy directly from farmers — no middlemen</p></div>
</div>
<div class="search-bar">
  <form method="get" action="${pageContext.request.contextPath}/crops/list" style="display:flex;gap:12px;flex-wrap:wrap;width:100%;align-items:flex-end">
    <div style="flex:2;min-width:160px">
      <label class="form-label" style="font-size:12px">Search Crop</label>
      <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Wheat, Onion, Cotton...">
    </div>
    <div style="flex:1;min-width:130px">
      <label class="form-label" style="font-size:12px">Category</label>
      <select name="category" class="form-control">
        <option value="">All Categories</option>
        <c:forEach var="cat" items="${['Cereals','Pulses','Oilseeds','Vegetables','Fruits','Spices','Cotton','Sugarcane','Other']}">
          <option value="${cat}" ${category==cat?'selected':''}>${cat}</option>
        </c:forEach>
      </select>
    </div>
    <div style="flex:1;min-width:130px">
      <label class="form-label" style="font-size:12px">State</label>
      <input type="text" name="state" value="${state}" class="form-control" placeholder="Maharashtra...">
    </div>
    <button type="submit" class="btn btn-primary" style="align-self:flex-end">Search</button>
    <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-secondary" style="align-self:flex-end">Reset</a>
  </form>
</div>
<c:choose>
  <c:when test="${empty crops}">
    <div class="empty-state"><div class="empty-icon">&#127807;</div><h3>No crops found</h3><p>Try adjusting your search filters.</p></div>
  </c:when>
  <c:otherwise>
    <p class="text-muted mb-2" style="font-size:13px">${crops.size()} crops found</p>
    <div class="crop-grid">
      <c:forEach var="crop" items="${crops}">
        <div class="crop-card">
          <c:choose>
            <c:when test="${not empty crop.photoUrl}"><img class="crop-card-img" src="${pageContext.request.contextPath}${crop.photoUrl}" alt="${crop.name}"></c:when>
            <c:otherwise><div class="crop-card-placeholder">&#127807;</div></c:otherwise>
          </c:choose>
          <div class="crop-card-body">
            <div class="crop-card-head"><span class="crop-card-title">${crop.name}</span><span class="badge badge-green">${crop.category}</span></div>
            <div class="crop-card-meta">&#128205; ${crop.farmerVillage}, ${crop.state}<br>&#128101; ${crop.farmerName} &bull; ${crop.quantity} ${crop.unit} available</div>
            <div class="crop-card-price">&#8377;${crop.pricePerUnit} <span>/ ${crop.unit}</span></div>
            <div class="crop-actions">
              <a href="${pageContext.request.contextPath}/crops/detail/${crop.id}" class="btn btn-secondary btn-sm w-full">Details</a>
              <a href="${pageContext.request.contextPath}/buyer/order/place/${crop.id}" class="btn btn-primary btn-sm w-full">Buy Now</a>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>