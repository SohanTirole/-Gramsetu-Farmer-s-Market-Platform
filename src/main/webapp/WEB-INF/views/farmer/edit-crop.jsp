<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Edit Crop"/>
<div style="max-width:680px;margin:0 auto">
  <div class="page-header">
    <div><h1>Edit Crop</h1><p>Update your listing details</p></div>
    <a href="${pageContext.request.contextPath}/farmer/crops" class="btn btn-outline">&#8592; My Crops</a>
  </div>
  <div class="card">
    <form action="${pageContext.request.contextPath}/farmer/crops/edit/${crop.id}" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Crop Name *</label>
          <input type="text" name="name" class="form-control" value="${crop.name}" required></div>
        <div class="form-group"><label class="form-label">Category *</label>
          <select name="category" class="form-control" required>
            <c:forEach var="cat" items="${['Cereals','Pulses','Oilseeds','Vegetables','Fruits','Spices','Cotton','Sugarcane','Other']}">
              <option value="${cat}" ${crop.category==cat?'selected':''}>${cat}</option>
            </c:forEach>
          </select></div>
      </div>
      <div class="form-row">
        <div class="form-group"><label class="form-label">Quantity *</label>
          <input type="number" name="quantity" class="form-control" value="${crop.quantity}" step="0.01" required></div>
        <div class="form-group"><label class="form-label">Unit</label>
          <select name="unit" class="form-control">
            <c:forEach var="u" items="${['kg','quintal','ton','piece','dozen','litre']}">
              <option value="${u}" ${crop.unit==u?'selected':''}>${u}</option>
            </c:forEach>
          </select></div>
      </div>
      <div class="form-group"><label class="form-label">Price per Unit (&#8377;) *</label>
        <input type="number" name="pricePerUnit" class="form-control" value="${crop.pricePerUnit}" step="0.01" required></div>
      <div class="form-group"><label class="form-label">Description</label>
        <textarea name="description" class="form-control" rows="3">${crop.description}</textarea></div>
      <div class="form-group"><label class="form-label">Available for Sale</label>
        <select name="available" class="form-control">
          <option value="true" ${crop.available?'selected':''}>Yes — Available</option>
          <option value="false" ${!crop.available?'selected':''}>No — Sold Out</option>
        </select></div>
      <c:if test="${not empty crop.photoUrl}">
        <div class="form-group"><label class="form-label">Current Photo</label><br>
          <img src="${pageContext.request.contextPath}${crop.photoUrl}" style="max-height:140px;border-radius:8px;border:1px solid var(--border)"></div>
      </c:if>
      <div class="form-group"><label class="form-label">Replace Photo (optional)</label>
        <input type="file" name="photo" class="form-control" accept="image/*" onchange="previewImg(this,'editPrev')">
        <img id="editPrev" src="#" style="display:none;margin-top:10px;max-height:140px;border-radius:8px"></div>
      <div class="d-flex gap-2 mt-3">
        <button type="submit" class="btn btn-primary btn-lg">Save Changes</button>
        <a href="${pageContext.request.contextPath}/farmer/crops" class="btn btn-outline btn-lg">Cancel</a>
      </div>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>