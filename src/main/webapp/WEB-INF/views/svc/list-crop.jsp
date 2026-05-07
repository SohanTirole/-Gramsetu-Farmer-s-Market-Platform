<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="List Crop for Farmer"/>
<div style="max-width:680px;margin:0 auto">
  <div class="page-header"><div><h1>List a Crop</h1><p>List crop on behalf of a registered farmer</p></div>
    <a href="${pageContext.request.contextPath}/svc/dashboard" class="btn btn-outline">&#8592; Dashboard</a></div>
  <div class="card">
    <form action="${pageContext.request.contextPath}/svc/list-crop" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-group"><label class="form-label">Select Farmer *</label>
        <select name="farmerId" class="form-control" required>
          <option value="">— Select Farmer —</option>
          <c:forEach var="f" items="${farmers}">
            <option value="${f.id}" ${param.farmerId == f.id ? 'selected' : ''}>${f.name} — ${f.village}</option>
          </c:forEach>
        </select></div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Crop Name *</label><input type="text" name="name" class="form-control" required></div>
        <div class="form-group"><label class="form-label">Category *</label>
          <select name="category" class="form-control" required>
            <option value="">— Select —</option>
            <option>Cereals</option><option>Pulses</option><option>Oilseeds</option>
            <option>Vegetables</option><option>Fruits</option><option>Spices</option>
            <option>Cotton</option><option>Sugarcane</option><option>Other</option>
          </select></div>
      </div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Quantity *</label><input type="number" name="quantity" class="form-control" step="0.01" required></div>
        <div class="form-group"><label class="form-label">Unit</label>
          <select name="unit" class="form-control">
            <option value="kg">kg</option><option value="quintal">quintal</option>
            <option value="ton">ton</option><option value="piece">piece</option>
          </select></div>
      </div>
      <div class="form-group"><label class="form-label">Price per Unit (&#8377;) *</label><input type="number" name="pricePerUnit" class="form-control" step="0.01" required></div>
      <div class="form-group"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="3"></textarea></div>
      <div class="form-group"><label class="form-label">Crop Photo</label>
        <input type="file" name="photo" class="form-control" accept="image/*" onchange="previewImg(this,'listPrev')">
        <img id="listPrev" src="#" style="display:none;margin-top:10px;max-height:140px;border-radius:8px"></div>
      <button type="submit" class="btn btn-primary btn-lg w-full">List This Crop</button>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>