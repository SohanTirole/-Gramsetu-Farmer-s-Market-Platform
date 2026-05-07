<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Notifications"/>
<div class="page-header"><div><h1>Notifications</h1></div></div>
<c:choose>
  <c:when test="${empty notifications}">
    <div class="card"><div class="empty-state"><div class="empty-icon">&#128276;</div><h3>All caught up!</h3></div></div>
  </c:when>
  <c:otherwise>
    <c:forEach var="n" items="${notifications}">
      <div class="notif-item ${!n.is_read ? 'unread' : ''}">
        <div class="notif-type">${n.type}</div>
        <div class="notif-msg">${n.message}</div>
        <div class="notif-time">&#128336; ${n.created_at}</div>
      </div>
    </c:forEach>
  </c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>