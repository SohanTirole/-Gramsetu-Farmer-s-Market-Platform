<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="List New Crop"/>
<div style="max-width:700px;margin:0 auto">
  <div class="page-header">
    <div><h1>&#127807; List a New Crop</h1><p>Sell directly to buyers at your own price</p></div>
    <a href="${pageContext.request.contextPath}/farmer/crops" class="btn btn-secondary">&larr; Back</a>
  </div>
  <div class="card">
    <form action="${pageContext.request.contextPath}/farmer/crops/add" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Crop Name *</label>
          <input type="text" name="name" class="form-control" placeholder="e.g. Wheat, Onion, Soybean"
                 maxlength="100" required>
        </div>
        <div class="form-group">
          <label class="form-label">Category *</label>
          <select name="category" class="form-control" required>
            <option value="">-- Select --</option>
            <c:forEach var="cat" items="${['Cereals','Pulses','Oilseeds','Vegetables','Fruits','Spices','Cotton','Sugarcane','Other']}">
              <option value="${cat}">${cat}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Quantity *</label>
          <input type="number" name="quantity" class="form-control" placeholder="500"
                 step="0.01" min="0.01" required>
        </div>
        <div class="form-group">
          <label class="form-label">Unit *</label>
          <select name="unit" class="form-control" required>
            <option value="kg">Kilogram (kg)</option>
            <option value="quintal">Quintal</option>
            <option value="ton">Ton</option>
            <option value="piece">Piece</option>
            <option value="dozen">Dozen</option>
            <option value="litre">Litre</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Price per Unit (&#8377;) *</label>
        <input type="number" name="pricePerUnit" class="form-control" placeholder="25.00"
               step="0.01" min="0.01" required>
        <p class="form-hint">Check <a href="${pageContext.request.contextPath}/farmer/prices" target="_blank">Price Trends</a> before setting your price.</p>
      </div>
      <div class="form-group">
        <label class="form-label">Description</label>
        <textarea name="description" class="form-control" rows="3"
                  placeholder="Quality grade, harvest date, organic/non-organic..." maxlength="1000"></textarea>
      </div>
      <div class="form-group">
        <label class="form-label">Crop Photo</label>
        <input type="file" id="cropPhotoInput" name="photo" class="form-control" accept="image/*">
        <img id="cropPreview" src="" alt="Preview"
             style="display:none;margin-top:10px;max-height:180px;border-radius:10px;border:1px solid var(--border)">
      </div>
      <button type="submit" class="btn btn-primary btn-lg w-full">&#127807; List This Crop</button>
    </form>
  </div>
</div>
<script>
  document.getElementById('cropPhotoInput').addEventListener('change', function(e) {
    var file = e.target.files[0];
    var preview = document.getElementById('cropPreview');
    if (file) {
      var reader = new FileReader();
      reader.onload = function(ev) {
        preview.src = ev.target.result;
        preview.style.display = 'block';
      };
      reader.readAsDataURL(file);
    } else {
      preview.src = '';
      preview.style.display = 'none';
    }
  });
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
