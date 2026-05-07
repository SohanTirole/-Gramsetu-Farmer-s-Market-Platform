<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Notifications"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Farmer</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/farmer/notifications" class="active"><span class="sidebar-icon">&#128276;</span>Notifications</a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>&#128276; Notifications</h1></div></div>
  <c:choose>
    <c:when test="${empty notifications}">
      <div class="card"><div class="empty-state"><div class="empty-icon">&#128276;</div><h3>All caught up!</h3><p>No notifications yet.</p></div></div>
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
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>