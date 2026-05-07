<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Home"/>
<style>.page-wrap{padding:0}.page-wrap>.container{max-width:100%;padding:0}</style>

<section class="hero">
  <div class="container hero-content">
    <div class="hero-badge">&#127807; India's Rural Marketplace</div>
    <h1>From Farm to Table,<br><span>No Middleman</span></h1>
    <p>GramSetu connects farmers directly to buyers across India — fair prices, soil advisory, government schemes, and village-level support all in one platform.</p>
    <div class="hero-btns">
      <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-xl btn-white">Browse Marketplace</a>
      <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-xl btn-outline-white">Join as Farmer</a>
    </div>
  </div>
</section>

<section style="background:var(--white);padding:36px 0">
  <div class="container">
    <div class="stats-grid" style="max-width:800px;margin:0 auto">
      <div class="stat-card"><div class="stat-val">${totalFarmers}+</div><div class="stat-label">Farmers Registered</div></div>
      <div class="stat-card terra"><div class="stat-val">${totalCrops}+</div><div class="stat-label">Crops Listed</div></div>
      <div class="stat-card gold"><div class="stat-val">${totalOrders}+</div><div class="stat-label">Orders Completed</div></div>
      <div class="stat-card blue"><div class="stat-val">${totalSvc}+</div><div class="stat-label">Village Centres</div></div>
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="section-head">
      <h2>Everything a Farmer Needs</h2>
      <p>From listing crops to expert soil advice — all under one roof.</p>
      <div class="section-line"></div>
    </div>
    <div class="feature-grid">
      <div class="feature-card"><div class="feature-icon">&#127807;</div><h3>Direct Marketplace</h3><p>Sell crops at your own price directly to buyers. Zero commission for farmers.</p></div>
      <div class="feature-card"><div class="feature-icon">&#128200;</div><h3>Price Intelligence</h3><p>Compare MSP vs live market prices before setting your selling rate.</p></div>
      <div class="feature-card"><div class="feature-icon">&#129526;</div><h3>Soil Advisory</h3><p>Upload soil photos and get personalised crop recommendations from certified agronomists.</p></div>
      <div class="feature-card"><div class="feature-icon">&#127968;</div><h3>Smart Village Centres</h3><p>SVC agents help offline farmers access all services — even without a smartphone.</p></div>
      <div class="feature-card"><div class="feature-icon">&#128196;</div><h3>Govt Scheme Finder</h3><p>PM-KISAN, Fasal Bima, Kisan Credit Card — check eligibility and apply instantly.</p></div>
      <div class="feature-card"><div class="feature-icon">&#128666;</div><h3>Logistics Support</h3><p>Book transport and track delivery from farm to buyer in real time.</p></div>
      <div class="feature-card"><div class="feature-icon">&#128172;</div><h3>Community Forum</h3><p>Ask crop questions, share pest alerts and get expert answers.</p></div>
      <div class="feature-card"><div class="feature-icon">&#128663;</div><h3>Equipment Rental</h3><p>Book tractors, harvesters and drones from nearby owners at daily rates.</p></div>
    </div>
  </div>
</section>

<section class="section" style="background:var(--cream)">
  <div class="container">
    <div class="section-head">
      <h2>Latest Crops Available</h2>
      <p>Fresh listings from farmers across India</p>
      <div class="section-line"></div>
    </div>
    <div class="crop-grid">
      <c:forEach var="crop" items="${recentCrops}">
        <div class="crop-card">
          <c:choose>
            <c:when test="${not empty crop.photoUrl}">
              <img class="crop-card-img" src="${pageContext.request.contextPath}${crop.photoUrl}" alt="${crop.name}">
            </c:when>
            <c:otherwise>
              <div class="crop-card-placeholder">&#127807;</div>
            </c:otherwise>
          </c:choose>
          <div class="crop-card-body">
            <div class="crop-card-head">
              <span class="crop-card-title">${crop.name}</span>
              <span class="badge badge-green">${crop.category}</span>
            </div>
            <div class="crop-card-meta">&#128205; ${crop.farmerVillage}, ${crop.state}<br>&#128101; ${crop.farmerName} &bull; ${crop.quantity} ${crop.unit}</div>
            <div class="crop-card-price">&#8377;${crop.pricePerUnit} <span>per ${crop.unit}</span></div>
            <div class="crop-actions">
              <a href="${pageContext.request.contextPath}/crops/detail/${crop.id}" class="btn btn-secondary btn-sm w-full">Details</a>
              <a href="${pageContext.request.contextPath}/buyer/order/place/${crop.id}" class="btn btn-primary btn-sm w-full">Buy Now</a>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
    <div class="text-center mt-3">
      <a href="${pageContext.request.contextPath}/crops/list" class="btn btn-primary btn-lg">View All Crops &rarr;</a>
    </div>
  </div>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>