<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Government Schemes"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Farmer</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/farmer/prices"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes" class="active"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>Government Schemes</h1><p>Apply for central & state farmer welfare schemes</p></div></div>
  <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:20px;margin-bottom:28px">
    <c:forEach var="s" items="${schemes}">
      <div class="card" style="border-top:4px solid var(--forest-mid)">
        <div class="card-header">
          <span class="card-title">${s.scheme_name}</span>
          <span class="badge badge-success">Active</span>
        </div>
        <p style="font-size:12px;color:var(--ink-ghost);margin-bottom:8px">&#127963; ${s.ministry}</p>
        <p style="font-size:14px;margin-bottom:10px">${s.description}</p>
        <div style="background:var(--forest-pale);border-radius:var(--radius);padding:10px 14px;margin-bottom:10px">
          <span style="font-size:12px;font-weight:700;color:var(--forest)">Benefits: </span>
          <span style="font-size:13px;color:var(--forest)">${s.benefits}</span>
        </div>
        <div class="d-flex gap-2">
          <c:if test="${not empty s.apply_url}">
            <a href="${s.apply_url}" target="_blank" class="btn btn-sm btn-outline">Official Site &#8599;</a>
          </c:if>
          <form action="${pageContext.request.contextPath}/farmer/schemes/apply/${s.id}" method="post" style="margin:0">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-sm btn-primary">Apply via GramSetu</button>
          </form>
        </div>
      </div>
    </c:forEach>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">My Applications</span></div>
    <c:choose>
      <c:when test="${empty applications}"><div class="empty-state"><div class="empty-icon">&#128196;</div><h3>No applications yet</h3></div></c:when>
      <c:otherwise>
        <div class="table-wrap"><table class="gs-table">
          <thead><tr><th>Scheme</th><th>Applied On</th><th>Status</th><th>Remarks</th></tr></thead>
          <tbody>
            <c:forEach var="a" items="${applications}">
              <tr>
                <td><strong>${a.scheme_name}</strong></td>
                <td><small>${a.applied_at}</small></td>
                <td>
                  <c:choose>
                    <c:when test="${a.status=='APPROVED'}">   <span class="badge badge-success">${a.status}</span></c:when>
                    <c:when test="${a.status=='REJECTED'}">   <span class="badge badge-danger">${a.status}</span></c:when>
                    <c:when test="${a.status=='SUBMITTED'}">  <span class="badge badge-warning">${a.status}</span></c:when>
                    <c:otherwise>                             <span class="badge badge-info">${a.status}</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${not empty a.remarks ? a.remarks : '—'}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table></div>
      </c:otherwise>
    </c:choose>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>