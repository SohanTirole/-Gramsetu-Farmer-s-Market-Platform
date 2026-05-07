<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile"/>
<div style="max-width:640px;margin:0 auto">
  <div class="page-header"><div><h1>My Profile</h1></div></div>
  <div class="card mb-3" style="display:flex;align-items:center;gap:20px;padding:28px">
    <div style="width:68px;height:68px;border-radius:50%;background:var(--terra-mid);display:flex;align-items:center;justify-content:center;font-family:var(--font-head);font-size:26px;font-weight:700;color:var(--white)">${user.initials}</div>
    <div><h2 style="font-family:var(--font-head);font-size:1.2rem">${user.name}</h2>
      <p class="text-muted">${user.email}</p><span class="badge badge-info mt-1">BUYER</span></div>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">Update Profile</span></div>
    <form action="${pageContext.request.contextPath}/buyer/profile/update" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Full Name</label><input type="text" name="name" class="form-control" value="${user.name}" required></div>
        <div class="form-group"><label class="form-label">Phone</label><input type="tel" name="phone" class="form-control" value="${user.phone}"></div>
      </div>
      <div class="form-row-three">
        <div class="form-group"><label class="form-label">City/Village</label><input type="text" name="village" class="form-control" value="${user.village}"></div>
        <div class="form-group"><label class="form-label">District</label><input type="text" name="district" class="form-control" value="${user.district}"></div>
        <div class="form-group"><label class="form-label">State</label><input type="text" name="state" class="form-control" value="${user.state}"></div>
      </div>
      <button type="submit" class="btn btn-primary">Save Changes</button>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>