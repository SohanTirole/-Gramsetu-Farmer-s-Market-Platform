<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Forum Post"/>
<div class="page-header">
  <a href="${pageContext.request.contextPath}/forum" class="btn btn-secondary">&larr; Back to Forum</a>
</div>
<div class="card mb-3">
  <div class="card-header">
    <div><span class="card-title">${post.title}</span><span class="forum-cat cat-${post.category}" style="margin-left:10px">${post.category.replace('_',' ')}</span></div>
    <span class="badge badge-gray">&#128077; ${post.upvotes}</span>
  </div>
  <p style="font-size:15px;line-height:1.75;margin-bottom:18px">${post.content}</p>
  <div style="display:flex;align-items:center;justify-content:space-between;border-top:1px solid var(--border);padding-top:14px">
    <span class="text-muted">By <strong>${post.author_name}</strong> &bull; ${post.created_at}</span>
    <sec:authorize access="isAuthenticated()">
      <form action="${pageContext.request.contextPath}/farmer/forum/upvote/${post.id}" method="post" style="display:inline">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-secondary btn-sm">&#128077; Upvote</button>
      </form>
    </sec:authorize>
  </div>
</div>
<h3 style="font-family:var(--font-head);font-size:1rem;margin-bottom:14px">&#128172; ${replies.size()} ${replies.size()==1?'Reply':'Replies'}</h3>
<c:forEach var="reply" items="${replies}">
  <div class="card mb-2" style="${reply.is_expert==1?'border-left:4px solid var(--forest-mid)':''}">
    <div style="display:flex;gap:12px;align-items:flex-start">
      <div style="width:36px;height:36px;border-radius:50%;background:${reply.is_expert==1?'var(--forest-pale)':'var(--cream)'};display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:${reply.is_expert==1?'var(--forest)':'var(--ink-lite)'};flex-shrink:0">
        ${reply.author_name.substring(0,1).toUpperCase()}
      </div>
      <div style="flex:1">
        <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px">
          <strong style="font-size:14px">${reply.author_name}</strong>
          <c:if test="${reply.is_expert == 1}"><span class="badge badge-green" style="font-size:11px">&#10003; Expert</span></c:if>
          <span class="text-muted" style="font-size:12px">${reply.created_at}</span>
        </div>
        <p style="font-size:14px;line-height:1.65">${reply.content}</p>
      </div>
    </div>
  </div>
</c:forEach>
<sec:authorize access="isAuthenticated()">
  <div class="card mt-3">
    <div class="card-header"><span class="card-title">&#9997; Add Your Reply</span></div>
    <form action="${pageContext.request.contextPath}/farmer/forum/reply/${post.id}" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-group">
        <textarea name="content" class="form-control" rows="4" placeholder="Share your knowledge or experience..." required></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Post Reply</button>
    </form>
  </div>
</sec:authorize>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>