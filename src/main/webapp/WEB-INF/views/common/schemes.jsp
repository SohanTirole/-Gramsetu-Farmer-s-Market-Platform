<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Government Schemes"/>
<div class="page-header"><div><h1>&#128196; Government Schemes</h1><p>Central and state schemes for farmers</p></div></div>
<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:22px">
  <c:forEach var="s" items="${schemes}">
    <div class="card" style="border-top:4px solid var(--forest-mid)">
      <div class="card-header">
        <span class="card-title">${s.scheme_name}</span>
        <span class="badge badge-green">Active</span>
      </div>
      <p style="font-size:12.5px;color:var(--ink-lite);margin-bottom:10px">&#127963; ${s.ministry}</p>
      <p style="font-size:14px;margin-bottom:14px">${s.description}</p>
      <div style="background:var(--forest-pale);border-radius:8px;padding:10px 14px;margin-bottom:10px">
        <p style="font-size:12px;font-weight:700;color:var(--forest);margin-bottom:3px">&#10003; Benefits</p>
        <p style="font-size:13px;color:var(--forest)">${s.benefits}</p>
      </div>
      <div style="background:var(--gold-pale);border-radius:8px;padding:10px 14px;margin-bottom:14px">
        <p style="font-size:12px;font-weight:700;color:#92670f;margin-bottom:3px">&#128101; Eligibility</p>
        <p style="font-size:13px;color:#92670f">${s.eligibility}</p>
      </div>
      <c:if test="${not empty s.apply_url}">
        <a href="${s.apply_url}" target="_blank" class="btn btn-primary btn-sm w-full">Apply on Official Site &#8599;</a>
      </c:if>
    </div>
  </c:forEach>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>