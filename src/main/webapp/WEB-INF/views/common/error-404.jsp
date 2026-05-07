<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>GramSetu — Page Not Found</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head><body>
<div style="display:flex;align-items:center;justify-content:center;min-height:100vh;flex-direction:column;gap:18px;text-align:center;padding:24px">
  <div style="font-size:80px">🌾</div>
  <h1 style="font-size:2rem">404 — Page Not Found</h1>
  <p class="text-muted">The page you're looking for doesn't exist or has been moved.</p>
  <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Go to Home</a>
</div>
</body></html>
