<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Soil Advisories"/>
<div class="page-header"><div><h1>&#129526; Soil Advisory Requests</h1><p>Review and respond to farmer soil requests</p></div></div>
<c:forEach var="a" items="${advisories}">
  <div class="card mb-3">
    <div class="card-header">
      <div><span class="card-title">${a.farmer_name}</span><small class="text-muted" style="margin-left:10px">&#128205; ${a.farmer_village} &bull; &#128336; ${a.submitted_at}</small></div>
      <c:choose><c:when test="${a.status=='COMPLETED'}"><span class="badge badge-green">COMPLETED</span></c:when><c:when test="${a.status=='PENDING'}"><span class="badge badge-amber">PENDING</span></c:when><c:otherwise><span class="badge badge-blue">${a.status}</span></c:otherwise></c:choose>
    </div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
      <div>
        <p class="form-label" style="margin-bottom:6px">Farmer Description</p>
        <p style="font-size:14px">${a.soil_description}</p>
        <c:if test="${not empty a.photo_url}"><img src="${pageContext.request.contextPath}${a.photo_url}" alt="Soil" style="max-height:180px;border-radius:10px;margin-top:12px"></c:if>
      </div>
      <div>
        <c:choose>
          <c:when test="${a.status=='COMPLETED'}">
            <p class="form-label" style="margin-bottom:6px">Your Recommendation</p>
            <div style="background:var(--forest-pale);padding:14px;border-radius:10px;font-size:14px;color:var(--forest)">${a.recommendation}</div>
          </c:when>
          <c:otherwise>
            <form action="${pageContext.request.contextPath}/agro/advisories/respond/${a.id}" method="post">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <div class="form-group">
                <label class="form-label">Your Recommendation *</label>
                <textarea name="recommendation" class="form-control" rows="6" placeholder="Soil health assessment, crop suggestions, fertiliser plan..." required></textarea>
              </div>
              <button type="submit" class="btn btn-primary w-full">Send Recommendation</button>
            </form>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</c:forEach>
<c:if test="${empty advisories}"><div class="empty-state"><div class="empty-icon">&#129526;</div><h3>No advisory requests yet</h3></div></c:if>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>