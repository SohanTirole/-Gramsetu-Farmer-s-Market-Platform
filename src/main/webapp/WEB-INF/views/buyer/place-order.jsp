<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Place Order"/>
<div style="max-width:680px;margin:0 auto">
  <div class="page-header"><div><h1>&#128230; Place Order</h1><p>Buy directly from the farmer</p></div><a href="${pageContext.request.contextPath}/crops/list" class="btn btn-secondary">&larr; Back</a></div>
  <div class="card mb-3">
    <div style="display:flex;gap:20px;align-items:center">
      <c:choose>
        <c:when test="${not empty crop.photoUrl}"><img src="${pageContext.request.contextPath}${crop.photoUrl}" alt="${crop.name}" style="width:100px;height:80px;object-fit:cover;border-radius:10px"></c:when>
        <c:otherwise><div class="crop-card-placeholder" style="width:100px;height:80px;border-radius:10px;font-size:32px">&#127807;</div></c:otherwise>
      </c:choose>
      <div>
        <h3 style="font-family:var(--font-head);margin-bottom:4px">${crop.name}</h3>
        <p class="text-muted">By ${crop.farmerName} &bull; ${crop.farmerVillage}, ${crop.state}</p>
        <p><span id="pricePerUnit" style="display:none">${crop.pricePerUnit}</span>
          <strong style="color:var(--terra);font-family:var(--font-head);font-size:1.1rem">&#8377;${crop.pricePerUnit}</strong> per ${crop.unit} &bull; ${crop.quantity} ${crop.unit} available</p>
      </div>
    </div>
  </div>
  <div class="card">
    <form action="${pageContext.request.contextPath}/buyer/order/place/${crop.id}" method="post">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="form-group">
        <label class="form-label">Quantity (${crop.unit}) *</label>
        <input type="number" id="orderQty" name="quantity" class="form-control" min="1" max="${crop.quantity}" step="0.01" placeholder="Enter quantity" required>
        <p class="form-hint">Available: ${crop.quantity} ${crop.unit}</p>
      </div>
      <div class="form-group">
        <label class="form-label">Estimated Total</label>
        <div id="orderTotal" style="font-family:var(--font-head);font-size:1.6rem;font-weight:800;color:var(--terra);padding:8px 0">&#8377; 0.00</div>
      </div>
      <div class="form-group">
        <label class="form-label">Payment Method *</label>
        <select name="paymentMethod" class="form-control" required>
          <option value="">-- Select --</option>
          <option value="UPI">UPI (Google Pay / PhonePe)</option>
          <option value="BANK_TRANSFER">Bank Transfer (NEFT/RTGS)</option>
          <option value="CASH_ON_DELIVERY">Cash on Delivery</option>
          <option value="RAZORPAY">Razorpay</option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Delivery Address *</label>
        <textarea name="deliveryAddress" class="form-control" placeholder="Full delivery address with pin code" required></textarea>
      </div>
      <div style="display:flex;gap:12px">
        <button type="submit" class="btn btn-primary btn-lg w-full">Confirm Order</button>
        <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-secondary btn-lg">Cancel</a>
      </div>
    </form>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>