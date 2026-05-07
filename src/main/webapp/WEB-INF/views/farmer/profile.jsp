<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Farmer</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/farmer/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/farmer/prices"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/farmer/profile" class="active"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>My Profile</h1></div></div>
  <div class="card mb-3" style="display:flex;align-items:center;gap:20px;padding:28px">
    <div style="width:72px;height:72px;border-radius:50%;background:var(--forest-mid);display:flex;align-items:center;justify-content:center;font-family:var(--font-head);font-size:28px;font-weight:700;color:var(--white);flex-shrink:0">${user.initials}</div>
    <div><h2 style="font-family:var(--font-head);font-size:1.3rem">${user.name}</h2>
      <p class="text-muted">${user.email}</p><span class="badge badge-success mt-1">FARMER</span></div>
  </div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">&#9999; Update Details</span></div>
    <form action="${pageContext.request.contextPath}/farmer/profile/update" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Full Name</label><input type="text" name="name" class="form-control" value="${user.name}" required></div>
        <div class="form-group"><label class="form-label">Phone</label><input type="tel" name="phone" class="form-control" value="${user.phone}"></div>
      </div>
      <div class="form-row-three">
        <div class="form-group"><label class="form-label">Village</label><input type="text" name="village" class="form-control" value="${user.village}"></div>
        <div class="form-group"><label class="form-label">District</label><input type="text" name="district" class="form-control" value="${user.district}"></div>
        <div class="form-group"><label class="form-label">State</label><input type="text" name="state" class="form-control" value="${user.state}"></div>
      </div>
      <button type="submit" class="btn btn-primary">Save Changes</button>
    </form>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">&#128274; Change Password</span></div>
    <form action="${pageContext.request.contextPath}/farmer/profile/change-password" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Current Password</label><input type="password" name="oldPassword" class="form-control" required></div>
        <div class="form-group"><label class="form-label">New Password</label><input type="password" name="newPassword" class="form-control" required></div>
      </div>
      <button type="submit" class="btn btn-warning">Update Password</button>
    </form>
  </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>