/* GramSetu v2 — main.js */
document.addEventListener('DOMContentLoaded', function () {

  // Auto-dismiss alerts after 4 seconds
  document.querySelectorAll('.alert').forEach(function (el) {
    setTimeout(function () {
      el.style.transition = 'opacity .4s, transform .4s';
      el.style.opacity = '0';
      el.style.transform = 'translateY(-6px)';
      setTimeout(function () { el.remove(); }, 400);
    }, 4500);
  });

  // Highlight active sidebar link
  var path = window.location.pathname;
  document.querySelectorAll('.dash-sidebar a').forEach(function (a) {
    var href = a.getAttribute('href');
    if (href && path.includes(href) && href.length > 1) a.classList.add('active');
  });

  // Confirm before destructive actions
  document.querySelectorAll('[data-confirm]').forEach(function (el) {
    el.addEventListener('click', function (e) {
      if (!confirm(el.getAttribute('data-confirm'))) e.preventDefault();
    });
  });

  // Image preview on file input
  document.querySelectorAll('input[data-preview]').forEach(function (input) {
    input.addEventListener('change', function () {
      var imgId = input.getAttribute('data-preview');
      var img   = document.getElementById(imgId);
      if (!img || !input.files || !input.files[0]) return;
      var reader = new FileReader();
      reader.onload = function (e) { img.src = e.target.result; img.style.display = 'block'; };
      reader.readAsDataURL(input.files[0]);
    });
  });

  // Order total calculator on place-order page
  var qtyInput   = document.getElementById('orderQty');
  var priceSpan  = document.getElementById('pricePerUnit');
  var totalSpan  = document.getElementById('orderTotal');
  if (qtyInput && priceSpan && totalSpan) {
    var ppu = parseFloat(priceSpan.textContent) || 0;
    qtyInput.addEventListener('input', function () {
      var qty   = parseFloat(qtyInput.value) || 0;
      var total = qty * ppu;
      totalSpan.textContent = '\u20B9' + total.toLocaleString('en-IN', {minimumFractionDigits: 2});
    });
  }
});

// Price trend chart via Chart.js
function renderPriceChart(canvasId, labels, mspData, marketData) {
  var ctx = document.getElementById(canvasId);
  if (!ctx) return;
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [
        { label: 'MSP (₹/Qtl)', data: mspData,
          backgroundColor: 'rgba(45,106,79,.65)', borderColor: '#2d6a4f', borderWidth: 1.5 },
        { label: 'Market Price (₹/Qtl)', data: marketData,
          backgroundColor: 'rgba(193,68,14,.65)', borderColor: '#c1440e', borderWidth: 1.5 }
      ]
    },
    options: {
      responsive: true,
      plugins: { legend: { position: 'top' } },
      scales: {
        y: { beginAtZero: false, ticks: { callback: function (v) { return '₹' + v.toLocaleString('en-IN'); } } }
      }
    }
  });
}

// Image preview helper used in edit-crop.jsp
function previewImg(input, previewId) {
  var img = document.getElementById(previewId);
  if (!img || !input.files || !input.files[0]) return;
  var reader = new FileReader();
  reader.onload = function(e) {
    img.src = e.target.result;
    img.style.display = 'block';
  };
  reader.readAsDataURL(input.files[0]);
}
