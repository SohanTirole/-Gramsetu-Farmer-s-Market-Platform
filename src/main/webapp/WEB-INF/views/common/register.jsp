<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html><html lang="en"><head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>GramSetu — Register</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head><body>
<div class="auth-wrap">
  <div class="auth-card" style="max-width:540px">
    <div class="auth-logo">
      <h1>&#127807; GramSetu</h1>
      <p>Create your free account</p>
    </div>
    <c:if test="${not empty errorMsg}"><div class="alert alert-error"><span class="alert-icon">&#9888;</span>${errorMsg}</div></c:if>
    <form action="${pageContext.request.contextPath}/auth/register" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Full Name *</label>
          <input type="text" name="name" class="form-control" placeholder="Ramesh Kumar" required>
        </div>
        <div class="form-group">
          <label class="form-label">Phone</label>
          <input type="tel" name="phone" class="form-control" placeholder="9XXXXXXXXX">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Email Address *</label>
        <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Password *</label>
          <input type="password" name="password" class="form-control" placeholder="Min 6 chars" required>
        </div>
        <div class="form-group">
          <label class="form-label">Confirm Password *</label>
          <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat" required>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">I am a *</label>
        <select name="role" class="form-control" required>
          <option value="">-- Select Role --</option>
          <option value="ROLE_FARMER">&#127807; Farmer</option>
          <option value="ROLE_BUYER">&#128230; Buyer / Trader</option>
          <option value="ROLE_SVC">&#127968; SVC Entrepreneur (Village Agent)</option>
          <option value="ROLE_AGRONOMIST">&#129526; Agronomist / Expert</option>
          <option value="ROLE_NGO">&#129309; NGO Partner</option>
        </select>
      </div>
      <div class="form-row three">
        <div class="form-group">
          <label class="form-label">Village</label>
          <input type="text" name="village" class="form-control" placeholder="Village">
        </div>
        <div class="form-group">
          <label class="form-label">District</label>
          <input type="text" name="district" class="form-control" placeholder="District">
        </div>
        <div class="form-group">
          <label class="form-label">State</label>
          <input type="text" name="state" class="form-control" placeholder="Maharashtra">
        </div>
      </div>
      <button type="submit" class="btn btn-primary btn-lg w-full">Create Account &rarr;</button>
    </form>
    <p class="text-center text-muted mt-2">Already have an account?
      <a href="${pageContext.request.contextPath}/auth/login" style="color:var(--forest-mid);font-weight:600">Login</a>
    </p>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body></html>