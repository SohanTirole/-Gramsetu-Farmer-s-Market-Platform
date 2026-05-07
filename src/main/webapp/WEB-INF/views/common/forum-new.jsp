<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="New Forum Post"/>
<div style="max-width:680px;margin:0 auto">
  <div class="page-header"><div><h1>&#128172; New Post</h1><p>Share your knowledge with the community</p></div><a href="${pageContext.request.contextPath}/forum" class="btn btn-secondary">&larr; Forum</a></div>
  <div class="card">
    <form action="${pageContext.request.contextPath}/farmer/forum/new" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-group"><label class="form-label">Title *</label><input type="text" name="title" class="form-control" placeholder="e.g. How to control aphids on wheat?" required></div>
      <div class="form-group">
        <label class="form-label">Category *</label>
        <select name="category" class="form-control" required>
          <option value="">-- Select --</option>
          <option value="CROP_ADVICE">&#127807; Crop Advice</option>
          <option value="PEST_ALERT">&#128027; Pest Alert</option>
          <option value="MARKET_INFO">&#128200; Market Info</option>
          <option value="GENERAL">&#128172; General</option>
        </select>
      </div>
      <div class="form-group"><label class="form-label">Content *</label><textarea name="content" class="form-control" rows="7" placeholder="Describe in detail..." required></textarea></div>
      <div style="display:flex;gap:12px"><button type="submit" class="btn btn-primary btn-lg">Publish Post</button><a href="${pageContext.request.contextPath}/forum" class="btn btn-secondary btn-lg">Cancel</a></div>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>