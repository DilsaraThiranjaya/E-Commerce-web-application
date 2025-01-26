<%@ page import="lk.ijse.ecommercewebapplication.dto.CartDetailDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body>
<%@include file="/includes/customer-header.jsp" %>

<div class="container py-5">
    <h1 class="text-white mb-4">Shopping Cart</h1>

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
        <!-- Cart Items -->
        <div class="col-lg-8">
            <div class="card bg-dark-secondary">
                <div class="card-body">
                    <%
                        List<CartDetailDTO> cartItems = (List<CartDetailDTO>) request.getAttribute("cartItems");
                        if (cartItems != null && !cartItems.isEmpty()) {
                            for (CartDetailDTO item : cartItems) {
                                String base64Image = Base64.getEncoder().encodeToString(item.getImage());
                    %>
                    <div class="cart-item <%= cartItems.indexOf(item) < cartItems.size() - 1 ? "mb-3 pb-3 border-bottom border-secondary" : "" %>">
                        <div class="d-flex gap-3">
                            <img src="data:image/png;base64,<%= base64Image %>"
                                 class="rounded" style="width: 100px; height: 100px; object-fit: cover;"
                                 alt="<%= item.getProductName() %>">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="text-white mb-1"><%= item.getProductName() %></h5>
                                        <p class="text-muted mb-0"><%= item.getDescription() %></p>
                                    </div>
                                    <button class="btn btn-link text-danger p-0" onclick="removeFromCart(<%= item.getItemCode() %>)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <button class="btn btn-sm btn-outline-secondary"
                                                onclick="updateQuantity(<%= item.getItemCode() %>, 'decrease')">-</button>
                                        <input type="number" class="form-control form-control-sm bg-dark border-secondary text-white"
                                               style="width: 60px;" value="<%= item.getQuantity() %>" min="1"
                                               onchange="updateQuantity(<%= item.getItemCode() %>, 'set', this.value)">
                                        <button class="btn btn-sm btn-outline-secondary"
                                                onclick="updateQuantity(<%= item.getItemCode() %>, 'increase')">+</button>
                                    </div>
                                    <span class="text-primary fw-bold">
                                        Rs. <%= String.format("%,.2f", item.getUnitPrice() * item.getQuantity()) %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="text-center py-4">
                        <p class="text-muted mb-0">Your cart is empty</p>
                    </div>
                    <%
                        }
                    %>
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
                        <span class="text-white" id="subtotal">
                            Rs. <%= String.format("%,.2f", request.getAttribute("subtotal")) %>
                        </span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Shipping</span>
                        <span class="text-white" id="shipping">
                            Rs. <%= String.format("%,.2f", request.getAttribute("shipping")) %>
                        </span>
                    </div>
                    <hr class="border-secondary">
                    <div class="d-flex justify-content-between mb-4">
                        <span class="text-white fw-bold">Total</span>
                        <span class="text-primary fw-bold" id="total">
                            Rs. <%= String.format("%,.2f", request.getAttribute("total")) %>
                        </span>
                    </div>
                    <% if (cartItems != null && !cartItems.isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100">
                        Proceed to Checkout
                    </a>
                    <% } else { %>
                    <button class="btn btn-primary w-100" disabled>Proceed to Checkout</button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>

<script>
    function updateQuantity(itemCode, action, value) {
        let quantity;
        const input = document.querySelector('input[onchange*="'+itemCode+'"]');
        const currentQty = parseInt(input.value);

        switch (action) {
            case 'increase':
                quantity = currentQty + 1;
                break;
            case 'decrease':
                quantity = currentQty > 1 ? currentQty - 1 : 1;
                break;
            case 'set':
                quantity = parseInt(value);
                if (quantity < 1) quantity = 1;
                break;
        }

        if (quantity === currentQty) return;

        fetch('/E_Commerce_web_application_war_exploded/cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=update&itemCode='+itemCode+'&quantity='+quantity
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    input.value = quantity;
                    updateOrderSummary(data);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to update quantity');
            });
    }

    function removeFromCart(itemCode) {
        if (!confirm('Are you sure you want to remove this item from your cart?')) return;

        fetch('/E_Commerce_web_application_war_exploded/cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=remove&itemCode='+itemCode
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to remove item from cart');
            });
    }

    function updateOrderSummary(data) {
        document.getElementById('subtotal').textContent =
            'Rs. ' + data.subtotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        document.getElementById('shipping').textContent =
            'Rs. ' + data.shipping.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        document.getElementById('total').textContent =
            'Rs. ' + data.total.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
    }

</script>

</body>
</html>