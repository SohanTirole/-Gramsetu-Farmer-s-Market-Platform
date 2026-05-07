<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Price Trends"/>
<div class="dash-layout">
<aside class="dash-sidebar">
  <p class="sidebar-title">Farmer</p>
  <a href="${pageContext.request.contextPath}/farmer/dashboard"><span class="sidebar-icon">&#127968;</span>Dashboard</a>
  <a href="${pageContext.request.contextPath}/farmer/crops"><span class="sidebar-icon">&#127807;</span>My Crops</a>
  <a href="${pageContext.request.contextPath}/farmer/orders"><span class="sidebar-icon">&#128230;</span>Orders</a>
  <a href="${pageContext.request.contextPath}/farmer/soil-advisory"><span class="sidebar-icon">&#129526;</span>Soil Advisory</a>
  <a href="${pageContext.request.contextPath}/farmer/prices" class="active"><span class="sidebar-icon">&#128200;</span>Price Trends</a>
  <a href="${pageContext.request.contextPath}/farmer/schemes"><span class="sidebar-icon">&#128196;</span>Schemes</a>
  <a href="${pageContext.request.contextPath}/farmer/profile"><span class="sidebar-icon">&#128100;</span>Profile</a>
</aside>
<div class="dash-main">
  <div class="page-header"><div><h1>MSP vs Market Prices</h1><p>Set the right price before listing your crops</p></div></div>
  <div class="card mb-3">
    <div class="card-header"><span class="card-title">Price Comparison Chart</span></div>
    <canvas id="priceChart" height="100"></canvas>
  </div>
  <div class="card">
    <div class="card-header"><span class="card-title">Latest Prices</span></div>
    <div class="price-table-wrap">
      <table class="gs-table">
        <thead><tr><th>Crop</th><th>MSP (&#8377;/Qtl)</th><th>Market (&#8377;/Qtl)</th><th>Difference</th><th>State</th></tr></thead>
        <tbody>
          <c:forEach var="p" items="${prices}">
            <c:set var="diff" value="${p.market_price - p.msp_price}"/>
            <tr>
              <td><strong>${p.crop_name}</strong></td>
              <td>&#8377;<fmt:formatNumber value="${p.msp_price}" pattern="#,##0"/></td>
              <td>&#8377;<fmt:formatNumber value="${p.market_price}" pattern="#,##0"/></td>
              <td>
                <c:choose>
                  <c:when test="${diff >= 0}"><span class="price-up">+&#8377;<fmt:formatNumber value="${diff}" pattern="#,##0"/></span></c:when>
                  <c:otherwise><span class="price-down">-&#8377;<fmt:formatNumber value="${-diff}" pattern="#,##0"/></span></c:otherwise>
                </c:choose>
              </td>
              <td>${p.state}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script>
var labels=[<c:forEach var="p" items="${prices}" varStatus="s">"${p.crop_name}"${!s.last?',':''}</c:forEach>];
var msp=[<c:forEach var="p" items="${prices}" varStatus="s">${p.msp_price}${!s.last?',':''}</c:forEach>];
var mkt=[<c:forEach var="p" items="${prices}" varStatus="s">${p.market_price}${!s.last?',':''}</c:forEach>];
renderPriceChart('priceChart',labels,msp,mkt);
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>