<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <%@include file="/includes/head.jsp" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/check-out.css">
</head>
<body>
<%@include file="/includes/customer-header.jsp" %>

<div class="container py-5">
  <h1 class="text-white mb-4">Checkout</h1>

  <div class="row g-4">
    <!-- Checkout Form -->
    <div class="col-lg-8">
      <div class="card bg-dark-secondary mb-4">
        <div class="card-body">
          <h5 class="card-title text-white mb-4">Shipping Information</h5>
          <form class="row g-3">
            <div class="col-12">
              <label class="form-label text-white">Address</label>
              <input type="text" class="form-control bg-dark border-secondary text-white">
            </div>
            <div class="col-md-6">
              <label class="form-label text-white">City</label>
              <input type="text" class="form-control bg-dark border-secondary text-white">
            </div>
            <div class="col-md-4">
              <label class="form-label text-white">State</label>
              <input type="text" class="form-control bg-dark border-secondary text-white">
            </div>
            <div class="col-md-2">
              <label class="form-label text-white">ZIP</label>
              <input type="text" class="form-control bg-dark border-secondary text-white">
            </div>
          </form>
        </div>
      </div>

      <div class="card bg-dark-secondary">
        <div class="card-body">
          <h5 class="card-title text-white mb-4">Payment Information</h5>
          <form class="row g-3">
            <!-- Payment Method Selection -->
            <div class="col-12">
              <label class="form-label text-white">Payment Method</label>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="paymentMethod" id="cardPayment" value="card" checked>
                <label class="form-check-label text-white" for="cardPayment">
                  Credit/Debit Card
                </label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="paymentMethod" id="codPayment" value="cod">
                <label class="form-check-label text-white" for="codPayment">
                  Cash on Delivery (COD)
                </label>
              </div>
            </div>

            <!-- Card Details Section -->
            <div id="cardDetails">
              <div class="col-12">
                <label class="form-label text-white">Card Number</label>
                <input type="text" class="form-control bg-dark border-secondary text-white"
                       placeholder="1234 5678 9012 3456">
              </div>
              <div class="row mt-3">
                <div class="col-md-6">
                  <label class="form-label text-white">Expiration Date</label>
                  <input type="text" class="form-control bg-dark border-secondary text-white"
                         placeholder="MM/YY">
                </div>
                <div class="col-md-6">
                  <label class="form-label text-white">CVV</label>
                  <input type="text" class="form-control bg-dark border-secondary text-white"
                         placeholder="123">
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Order Summary -->
    <div class="col-lg-4">
      <div class="card bg-dark-secondary">
        <div class="card-body">
          <h5 class="card-title text-white mb-4">Order Summary</h5>
          <div class="d-flex justify-content-between mb-2">
            <span class="text-muted">Subtotal</span>
            <span class="text-white">$2,499.98</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span class="text-muted">Shipping</span>
            <span class="text-white">$29.99</span>
          </div>
          <hr class="border-secondary">
          <div class="d-flex justify-content-between mb-4">
            <span class="text-white fw-bold">Total</span>
            <span class="text-primary fw-bold">$2,779.97</span>
          </div>
          <button class="btn btn-primary w-100">Place Order</button>
        </div>
      </div>
    </div>
  </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>

<script>
  // JavaScript to toggle card details visibility
  document.addEventListener('DOMContentLoaded', () => {
    const cardDetails = document.getElementById('cardDetails');
    const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');

    paymentMethods.forEach(method => {
      method.addEventListener('change', () => {
        if (method.value === 'card') {
          cardDetails.style.display = 'block';
        } else {
          cardDetails.style.display = 'none';
        }
      });
    });
  });
</script>
</body>
</html>
