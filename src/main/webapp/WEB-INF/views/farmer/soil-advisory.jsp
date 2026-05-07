<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Soil Advisory"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Farmer</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/farmer/soil-advisory" class="active"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/farmer/prices"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Soil Advisory</h1><p>Get expert crop recommendations for your soil</p></div></div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">+ Submit New Request</span></div>
    <form action="${pageContext.request.contextPath}/farmer/soil-advisory/submit" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-group"><label class="form-label">Describe Your Soil *</label>
        <textarea name="soilDescription" class="form-control" rows="4"
                  placeholder="Colour, texture, recent crops grown, visible issues, location..." required></textarea></div>
      <div class="form-group"><label class="form-label">Upload Soil Photo (optional)</label>
        <input type="file" name="photo" class="form-control" accept="image/*" onchange="previewImg(this,'soilPrev')">
        <img id="soilPrev" src="#" style="display:none;margin-top:10px;max-height:160px;border-radius:8px"></div>
      <button type="submit" class="btn btn-primary">Submit for Expert Review</button>
    </form>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">My Past Requests</span></div>
    <c:choose>
      <c:when test="${empty advisories}">
        <div class="empty-state"><div class="empty-icon">&#129526;</div>
          <h3>No requests yet</h3><p>Submit your soil details for a personalised crop recommendation.</p></div>
      </c:when>
      <c:otherwise>
        <c:forEach var="a" items="${advisories}">
          <div style="border:1px solid var(--border);border-radius:var(--radius-lg);padding:18px;margin-bottom:14px">
            <div class="d-flex justify-between align-center mb-2">
              <span class="text-muted" style="font-size:13px">&#128336; ${a.submitted_at}</span>
              <c:choose>
                <c:when test="${a.status=='COMPLETED'}"><span class="badge badge-success">Completed</span></c:when>
                <c:when test="${a.status=='PENDING'}">  <span class="badge badge-warning">Pending</span></c:when>
                <c:otherwise>                           <span class="badge badge-info">In Review</span></c:otherwise>
              </c:choose>
            </div>
            <p style="font-size:14px;margin-bottom:10px"><strong>Your description:</strong> ${a.soil_description}</p>
            <c:if test="${not empty a.photo_url}">
              <img src="${pageContext.request.contextPath}${a.photo_url}" style="max-height:120px;border-radius:6px;margin-bottom:10px">
            </c:if>
            <c:if test="${not empty a.recommendation}">
              <div style="background:var(--forest-pale);border-radius:var(--radius);padding:14px;border-left:4px solid var(--forest-mid)">
                <p style="font-size:12px;font-weight:700;color:var(--forest);margin-bottom:6px">&#10003; Expert Recommendation</p>
                <p style="font-size:14px;color:var(--forest)">${a.recommendation}</p>
              </div>
            </c:if>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>