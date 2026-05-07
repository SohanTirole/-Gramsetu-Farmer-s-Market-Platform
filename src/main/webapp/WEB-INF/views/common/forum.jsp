<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Community Forum"/>
<div class="page-header">
  <div><h1>&#128172; Community Forum</h1><p>Ask, share, and learn from the farming community</p></div>
  <sec:authorize access="isAuthenticated()">
    <a href="${pageContext.request.contextPath}/farmer/forum/new" class="btn btn-primary">+ New Post</a>
  </sec:authorize>
</div>
<div style="display:flex;gap:10px;margin-bottom:22px;flex-wrap:wrap">
  <a href="${pageContext.request.contextPath}/forum"                          class="btn btn-sm ${empty selectedCategory?'btn-primary':'btn-secondary'}">All Posts</a>
  <a href="${pageContext.request.contextPath}/forum?category=CROP_ADVICE"     class="btn btn-sm ${selectedCategory=='CROP_ADVICE'?'btn-primary':'btn-secondary'}">&#127807; Crop Advice</a>
  <a href="${pageContext.request.contextPath}/forum?category=PEST_ALERT"      class="btn btn-sm ${selectedCategory=='PEST_ALERT'?'btn-primary':'btn-secondary'}">&#128027; Pest Alerts</a>
  <a href="${pageContext.request.contextPath}/forum?category=MARKET_INFO"     class="btn btn-sm ${selectedCategory=='MARKET_INFO'?'btn-primary':'btn-secondary'}">&#128200; Market Info</a>
  <a href="${pageContext.request.contextPath}/forum?category=GENERAL"         class="btn btn-sm ${selectedCategory=='GENERAL'?'btn-primary':'btn-secondary'}">&#128172; General</a>
</div>
<c:choose>
  <c:when test="${empty posts}">
    <div class="empty-state"><div class="empty-icon">&#128172;</div><h3>No posts yet</h3><p>Be the first to start a discussion!</p></div>
  </c:when>
  <c:otherwise>
    <c:forEach var="post" items="${posts}">
      <div class="forum-post">
        <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:14px">
          <div style="flex:1">
            <div class="forum-post-title">
              <a href="${pageContext.request.contextPath}/forum/post/${post.id}" style="color:var(--ink);text-decoration:none">${post.title}</a>
              <span class="forum-cat cat-${post.category}">${post.category.replace('_',' ')}</span>
            </div>
            <div class="forum-meta" style="margin-top:6px">
              &#128100; <strong>${post.author_name}</strong> &bull; &#128336; ${post.created_at} &bull; &#128172; ${post.reply_count} replies &bull; &#128077; ${post.upvotes}
            </div>
          </div>
          <a href="${pageContext.request.contextPath}/forum/post/${post.id}" class="btn btn-secondary btn-sm">View &rarr;</a>
        </div>
      </div>
    </c:forEach>
  </c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>