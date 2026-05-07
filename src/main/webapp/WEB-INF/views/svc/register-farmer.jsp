<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Register Farmer"/>
<div style="max-width:640px;margin:0 auto">
  <div class="page-header"><div><h1>Register a Farmer</h1><p>Add a farmer to your cluster on their behalf</p></div>
    <a href="${pageContext.request.contextPath}/svc/dashboard" class="btn btn-outline">&#8592; Dashboard</a></div>
  <div class="card">
    <form action="${pageContext.request.contextPath}/svc/register-farmer" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Full Name *</label><input type="text" name="name" class="form-control" placeholder="Ramesh Kumar" required></div>
        <div class="form-group"><label class="form-label">Phone *</label><input type="tel" name="phone" class="form-control" placeholder="9XXXXXXXXX" required></div>
      </div>
      <div class="form-group"><label class="form-label">Email (optional)</label><input type="email" name="email" class="form-control" placeholder="farmer@example.com"></div>
      <div class="form-group"><label class="form-label">Aadhaar Number</label><input type="text" name="aadhaar" class="form-control" placeholder="XXXX XXXX XXXX"></div>
      <div class="form-row-three">
        <div class="form-group"><label class="form-label">Village *</label><input type="text" name="village" class="form-control" required></div>
        <div class="form-group"><label class="form-label">District *</label><input type="text" name="district" class="form-control" required></div>
        <div class="form-group"><label class="form-label">State *</label><input type="text" name="state" class="form-control" required></div>
      </div>
      <div class="form-group"><label class="form-label">Login Password *</label><input type="password" name="password" class="form-control" placeholder="Min 6 characters" required></div>
      <button type="submit" class="btn btn-primary btn-lg w-full">Register Farmer</button>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>