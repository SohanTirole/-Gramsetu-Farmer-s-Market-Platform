<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Manage Users"/>
<div class="page-header"><div><h1>&#128101; All Users</h1></div></div>
<div class="search-bar mb-3">
  <form method="get" style="display:flex;gap:10px;width:100%">
    <select name="role" class="form-control" style="max-width:200px">
      <option value="">All Roles</option>
      <option value="FARMER" ${param.role=='FARMER'?'selected':''}>Farmer</option>
      <option value="BUYER" ${param.role=='BUYER'?'selected':''}>Buyer</option>
      <option value="SVC" ${param.role=='SVC'?'selected':''}>SVC Agent</option>
      <option value="AGRONOMIST" ${param.role=='AGRONOMIST'?'selected':''}>Agronomist</option>
    </select>
    <button type="submit" class="btn btn-primary">Filter</button>
    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Reset</a>
  </form>
</div>
<div class="card"><div class="table-wrap"><table class="gs-table">
  <thead><tr><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Location</th><th>Status</th><th>Action</th></tr></thead>
  <tbody>
    <c:forEach var="u" items="${users}">
      <tr>
        <td><strong>${u.name}</strong></td><td>${u.email}</td><td>${u.phone}</td>
        <td><c:choose><c:when test="${u.role=='ROLE_FARMER'}"><span class="badge badge-green">FARMER</span></c:when><c:when test="${u.role=='ROLE_BUYER'}"><span class="badge badge-blue">BUYER</span></c:when><c:when test="${u.role=='ROLE_SVC'}"><span class="badge badge-purple">SVC</span></c:when><c:when test="${u.role=='ROLE_AGRONOMIST'}"><span class="badge badge-amber">AGRONOMIST</span></c:when><c:when test="${u.role=='ROLE_ADMIN'}"><span class="badge badge-red">ADMIN</span></c:when><c:otherwise><span class="badge badge-gray">${u.role}</span></c:otherwise></c:choose></td>
        <td>${u.village}, ${u.state}</td>
        <td><c:choose><c:when test="${u.active}"><span class="badge badge-green">Active</span></c:when><c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise></c:choose></td>
        <td><c:if test="${u.active && u.role != 'ROLE_ADMIN'}">
          <form action="${pageContext.request.contextPath}/admin/users/deactivate/${u.id}" method="post" style="display:inline"
                onsubmit="return confirm('Deactivate ${u.name}?')">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-danger btn-sm">Deactivate</button>
          </form>
        </c:if></td>
      </tr>
    </c:forEach>
  </tbody>
</table></div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>