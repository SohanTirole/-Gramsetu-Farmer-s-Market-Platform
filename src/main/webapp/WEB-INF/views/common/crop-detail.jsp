<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="${crop.name}"/>
<div class="page-header">
  <div><h1>${crop.name}</h1><p>Listed by ${crop.farmerName} from ${crop.farmerVillage}, ${crop.state}</p></div>
  <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-secondary">&larr; Back to Marketplace</a>
</div>
<div style="display:grid;grid-template-columns:2fr 1fr;gap:24px">
  <div>
    <div class="card">
      <c:choose>
        <c:when test="${not empty crop.photoUrl}">
          <img src="${pageContext.request.contextPath}${crop.photoUrl}" alt="${crop.name}" style="width:100%;max-height:360px;object-fit:cover;border-radius:10px;margin-bottom:20px">
        </c:when>
        <c:otherwise>
          <div class="crop-card-placeholder" style="height:220px;border-radius:10px;margin-bottom:20px;font-size:80px">&#127807;</div>
        </c:otherwise>
      </c:choose>
      <table class="gs-table">
        <tr><td class="text-muted" style="width:140px">Category</td><td><span class="badge badge-green">${crop.category}</span></td></tr>
        <tr><td class="text-muted">Available</td><td><strong>${crop.quantity} ${crop.unit}</strong></td></tr>
        <tr><td class="text-muted">Location</td><td>&#128205; ${crop.farmerVillage}, ${crop.district}, ${crop.state}</td></tr>
        <c:if test="${not empty crop.description}"><tr><td class="text-muted" style="vertical-align:top">Details</td><td>${crop.description}</td></tr></c:if>
      </table>
    </div>
  </div>
  <div>
    <div class="card" style="text-align:center;border-top:4px solid var(--terra)">
      <p class="text-muted" style="font-size:13px;margin-bottom:4px">Price per ${crop.unit}</p>
      <div style="font-family:var(--font-head);font-size:2.4rem;font-weight:800;color:var(--terra)">&#8377;${crop.pricePerUnit}</div>
      <p class="text-muted" style="font-size:13px;margin-top:4px">${crop.quantity} ${crop.unit} available</p>
      <c:choose>
        <c:when test="${crop.available}">
          <a href="${pageContext.request.contextPath}/buyer/order/place/${crop.id}" class="btn btn-primary btn-lg w-full mt-2">&#128230; Buy Now</a>
        </c:when>
        <c:otherwise><button class="btn btn-secondary btn-lg w-full mt-2" disabled>Sold Out</button></c:otherwise>
      </c:choose>
    </div>
    <div class="card">
      <div class="card-header"><span class="card-title">&#128100; About the Farmer</span></div>
      <table class="gs-table">
        <tr><td class="text-muted">Name</td><td><strong>${crop.farmerName}</strong></td></tr>
        <tr><td class="text-muted">Phone</td><td>${crop.farmerPhone}</td></tr>
        <tr><td class="text-muted">Village</td><td>${crop.farmerVillage}</td></tr>
        <tr><td class="text-muted">State</td><td>${crop.state}</td></tr>
      </table>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>