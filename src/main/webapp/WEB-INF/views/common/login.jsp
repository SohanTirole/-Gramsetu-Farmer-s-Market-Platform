<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>GramSetu — Login</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
	<div class="auth-wrap">
		<div class="auth-card">
			<div class="auth-logo">
				<h1>&#127807; GramSetu</h1>
				<p>Rural Empowerment Platform</p>
			</div>
			<c:if test="${not empty errorMsg}">
				<div class="alert alert-error">
					<span class="alert-icon">&#9888;</span>${errorMsg}</div>
			</c:if>
			<c:if test="${not empty successMsg}">
				<div class="alert alert-success">
					<span class="alert-icon">&#10003;</span>${successMsg}</div>
			</c:if>
			<form action="${pageContext.request.contextPath}/auth/login-process"
				method="post">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<div class="form-group">
					<label class="form-label">Email Address</label> <input type="text"
						name="email" class="form-control" placeholder="you@example.com"
						required autofocus>
				</div>
				<div class="form-group">
					<label class="form-label">Password</label> <input type="password"
						name="password" class="form-control"
						placeholder="Your password" required>
				</div>
				<button type="submit" class="btn btn-primary btn-lg w-full"
					style="margin-top: 8px">Sign In &rarr;</button>
			</form>
			<div class="auth-divider">or</div>
			<p class="text-center text-muted">
				Don't have an account? <a
					href="${pageContext.request.contextPath}/auth/register"
					style="color: var(--forest-mid); font-weight: 600">Register
					free</a>
			</p>
		</div>
	</div>
	<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>