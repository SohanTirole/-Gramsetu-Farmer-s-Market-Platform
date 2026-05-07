<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>GramSetu — Server Error</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head><body>
<div style="display:flex;align-items:center;justify-content:center;min-height:100vh;flex-direction:column;gap:18px;text-align:center;padding:24px">
  <div style="font-size:80px">⚠️</div>
  <h1 style="font-size:2rem">500 — Something Went Wrong</h1>
  <p class="text-muted">An unexpected error occurred. Please try again or contact support.</p>
  <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Go to Home</a>
</div>
</body></html>
