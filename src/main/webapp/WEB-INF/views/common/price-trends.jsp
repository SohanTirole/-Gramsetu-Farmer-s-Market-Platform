<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Price Trends"/>
<div class="page-header"><div><h1>&#128200; MSP vs Market Price Trends</h1><p>Compare government support price with live market prices</p></div></div>
<div class="card mb-3">
  <div class="card-header"><span class="card-title">Price Comparison Chart</span></div>
  <canvas id="priceChart" height="110"></canvas>
</div>
<div class="card">
  <div class="table-wrap">
    <table class="gs-table">
      <thead><tr><th>Crop</th><th>MSP (&#8377;/Qtl)</th><th>Market Price (&#8377;/Qtl)</th><th>Difference</th><th>State</th><th>Date</th></tr></thead>
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
                <c:otherwise><span class="price-down">&#8377;<fmt:formatNumber value="${diff}" pattern="#,##0"/></span></c:otherwise>
              </c:choose>
            </td>
            <td>${p.state}</td>
            <td><small>${p.recorded_date}</small></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<script>
var labels=[<c:forEach var="p" items="${prices}" varStatus="s">"${p.crop_name}"${!s.last?',':''}</c:forEach>];
var msp=[<c:forEach var="p" items="${prices}" varStatus="s">${p.msp_price}${!s.last?',':''}</c:forEach>];
var mkt=[<c:forEach var="p" items="${prices}" varStatus="s">${p.market_price}${!s.last?',':''}</c:forEach>];
renderPriceChart("priceChart",labels,msp,mkt);
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>