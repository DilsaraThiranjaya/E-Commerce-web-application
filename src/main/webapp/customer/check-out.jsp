<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="lk.ijse.ecommercewebapplication.dto.*" %>
<%@ page import="java.util.Base64" %>
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

  <!-- Display success or error messages -->
  <%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
  %>

  <% if (message != null) { %>
  <div class="alert alert-success">
    <%=message%>
  </div>
  <% } %>

  <% if (error != null) { %>
  <div class="alert alert-danger">
    <%=error%>
  </div>
  <% } %>

  <div class="row g-4">
    <!-- Checkout Form -->
    <div class="col-lg-8">
      <div class="card bg-dark-secondary mb-4">
        <div class="card-body">
          <h5 class="card-title text-white mb-4">Shipping Information</h5>
          <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="post" class="row g-3">
            <div class="col-12">
              <label class="form-label text-white">Address</label>
              <input type="text" name="address" class="form-control bg-dark border-secondary text-white" required>
            </div>
            <div class="col-md-6">
              <label class="form-label text-white">City</label>
              <input type="text" name="city" class="form-control bg-dark border-secondary text-white" required>
            </div>
            <div class="col-md-4">
              <label class="form-label text-white">State</label>
              <input type="text" name="state" class="form-control bg-dark border-secondary text-white" required>
            </div>
            <div class="col-md-2">
              <label class="form-label text-white">ZIP</label>
              <input type="text" name="zipCode" class="form-control bg-dark border-secondary text-white" required>
            </div>

            <div class="col-12">
              <label class="form-label text-white">Payment Method</label>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="paymentMethod" id="cardPayment" value="Card" checked>
                <label class="form-check-label text-white" for="cardPayment">
                  Credit/Debit Card
                </label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="paymentMethod" id="codPayment" value="COD">
                <label class="form-check-label text-white" for="codPayment">
                  Cash on Delivery (COD)
                </label>
              </div>
            </div>

            <!-- Card Details Section -->
            <div id="cardDetails">
              <div class="col-12">
                <label class="form-label text-white">Card Number</label>
                <input type="text" class="form-control bg-dark border-secondary text-white card-input"
                       placeholder="1234 5678 9012 3456" maxlength="19">
              </div>
              <div class="row mt-3">
                <div class="col-md-6">
                  <label class="form-label text-white">Expiration Date</label>
                  <input type="text" class="form-control bg-dark border-secondary text-white expiry-input"
                         placeholder="MM/YY" maxlength="5">
                </div>
                <div class="col-md-6">
                  <label class="form-label text-white">CVV</label>
                  <input type="text" class="form-control bg-dark border-secondary text-white cvv-input"
                         placeholder="123" maxlength="3">
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>

      <!-- Order Items -->
      <div class="card bg-dark-secondary mb-4">
        <div class="card-body">
          <h5 class="card-title text-white mb-4">Order Items</h5>
          <div class="table-responsive">
            <table class="table table-dark table-hover">
              <thead>
              <tr>
                <th>Image</th>
                <th>Product</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Total</th>
              </tr>
              </thead>
              <tbody>
              <%
                List<CartDetailDTO> cartDetails = (List<CartDetailDTO>) request.getAttribute("cartDetails");
                DecimalFormat df = new DecimalFormat("#,##0.00");
                if (cartDetails != null && !cartDetails.isEmpty()) {
                  for (CartDetailDTO detail : cartDetails) {
                    String base64Image = Base64.getEncoder().encodeToString(detail.getImage());
              %>
              <tr>
                <td>
                  <img src="data:image/jpeg;base64,<%= base64Image %>"
                       alt="<%= detail.getProductName() %>"
                       style="width: 50px; height: 50px; object-fit: cover;">
                </td>
                <td>
                  <div><%= detail.getProductName() %></div>
                  <small class="text-muted"><%= detail.getDescription() %></small>
                </td>
                <td><%= detail.getQuantity() %></td>
                <td>$<%= df.format(detail.getUnitPrice()) %></td>
                <td>$<%= df.format(detail.getUnitPrice() * detail.getQuantity()) %></td>
              </tr>
              <%
                  }
                }
              %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Order Summary -->
    <div class="col-lg-4">
      <div class="card bg-dark-secondary">
        <div class="card-body">
          <h5 class="card-title text-white mb-4">Order Summary</h5>

          <%
            OrderDTO orderDTO = (OrderDTO) request.getAttribute("orderDTO");
          %>
          <div class="d-flex justify-content-between mb-2">
            <span class="text-muted">Subtotal</span>
            <span class="text-white">Rs. <%= df.format(orderDTO.getSubTotal()) %></span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span class="text-muted">Shipping</span>
            <span class="text-white">Rs. <%= df.format(orderDTO.getShippingCost()) %></span>
          </div>
          <hr class="border-secondary">
          <div class="d-flex justify-content-between mb-4">
            <span class="text-white fw-bold">Total</span>
            <span class="text-primary fw-bold">$<%= df.format(request.getAttribute("total")) %></span>
          </div>
          <button type="submit" form="checkoutForm" class="btn btn-primary w-100">Place Order</button>
        </div>
      </div>
    </div>
  </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const cardDetails = document.getElementById('cardDetails');
    const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
    const cardInputs = document.querySelectorAll('#cardDetails input');

    // Function to format card number
    const formatCardNumber = (input) => {
      let value = input.value.replace(/\D/g, '');
      let formattedValue = '';
      for (let i = 0; i < value.length; i++) {
        if (i > 0 && i % 4 === 0) {
          formattedValue += ' ';
        }
        formattedValue += value[i];
      }
      input.value = formattedValue;
    };

    // Function to format expiry date
    const formatExpiryDate = (input) => {
      let value = input.value.replace(/\D/g, '');
      if (value.length >= 2) {
        value = value.substring(0, 2) + '/' + value.substring(2);
      }
      input.value = value;
    };

    // Add event listeners for input formatting
    document.querySelector('.card-input').addEventListener('input', (e) => {
      formatCardNumber(e.target);
    });

    document.querySelector('.expiry-input').addEventListener('input', (e) => {
      formatExpiryDate(e.target);
    });

    document.querySelector('.cvv-input').addEventListener('input', (e) => {
      e.target.value = e.target.value.replace(/\D/g, '');
    });

    // Toggle card details visibility and required attributes
    paymentMethods.forEach(method => {
      method.addEventListener('change', () => {
        const isCardPayment = method.value === 'Card';
        cardDetails.style.display = isCardPayment ? 'block' : 'none';

        cardInputs.forEach(input => {
          input.required = isCardPayment;
        });
      });
    });

    // Form validation
    document.getElementById('checkoutForm').addEventListener('submit', (e) => {
      const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

      if (paymentMethod === 'Card') {
        const cardNumber = document.querySelector('.card-input').value.replace(/\s/g, '');
        const expiry = document.querySelector('.expiry-input').value;
        const cvv = document.querySelector('.cvv-input').value;

        if (cardNumber.length !== 16) {
          e.preventDefault();
          alert('Please enter a valid card number');
          return;
        }

        if (!/^\d{2}\/\d{2}$/.test(expiry)) {
          e.preventDefault();
          alert('Please enter a valid expiry date (MM/YY)');
          return;
        }

        if (cvv.length !== 3) {
          e.preventDefault();
          alert('Please enter a valid CVV');
          return;
        }
      }
    });
  });
</script>
</body>
</html>