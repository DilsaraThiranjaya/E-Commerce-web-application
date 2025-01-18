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

    <div class="row g-4">
        <!-- Cart Items -->
        <div class="col-lg-8">
            <div class="card bg-dark-secondary">
                <div class="card-body">
                    <!-- Cart Item -->
                    <div class="cart-item mb-3 pb-3 border-bottom border-secondary">
                        <div class="d-flex gap-3">
                            <img src="https://images.unsplash.com/photo-1587202372634-32705e3bf49c?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80"
                                 class="rounded" style="width: 100px; height: 100px; object-fit: cover;" alt="Product">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="text-white mb-1">Gaming PC Pro</h5>
                                        <p class="text-muted mb-0">High-performance gaming desktop</p>
                                    </div>
                                    <button class="btn btn-link text-danger p-0">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <button class="btn btn-sm btn-outline-secondary" onclick="decreaseQty(this)">-</button>
                                        <input type="number" class="form-control form-control-sm bg-dark border-secondary text-white"
                                               style="width: 60px;" value="1" min="1">
                                        <button class="btn btn-sm btn-outline-secondary" onclick="increaseQty(this)">+</button>
                                    </div>
                                    <span class="text-primary fw-bold">$999.99</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Repeat cart item -->
                    <div class="cart-item">
                        <div class="d-flex gap-3">
                            <img src="https://images.unsplash.com/photo-1593640408182-31c70c8268f5?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80"
                                 class="rounded" style="width: 100px; height: 100px; object-fit: cover;" alt="Product">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="text-white mb-1">Gaming Laptop Elite</h5>
                                        <p class="text-muted mb-0">Premium gaming laptop</p>
                                    </div>
                                    <button class="btn btn-link text-danger p-0">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <button class="btn btn-sm btn-outline-secondary" onclick="decreaseQty(this)">-</button>
                                        <input type="number" class="form-control form-control-sm bg-dark border-secondary text-white"
                                               style="width: 60px; " value="1" min="1">
                                        <button class="btn btn-sm btn-outline-secondary" onclick="increaseQty(this)">+</button>
                                    </div>
                                    <span class="text-primary fw-bold">$1,499.99</span>
                                </div>
                            </div>
                        </div>
                    </div>
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
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Tax</span>
                        <span class="text-white">$250.00</span>
                    </div>
                    <hr class="border-secondary">
                    <div class="d-flex justify-content-between mb-4">
                        <span class="text-white fw-bold">Total</span>
                        <span class="text-primary fw-bold">$2,779.97</span>
                    </div>
                    <a href="checkout.html" class="btn btn-primary w-100">
                        Proceed to Checkout
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>

<script>
    function increaseQty(button) {
        const input = button.parentElement.querySelector('input[type="number"]');
        input.value = parseInt(input.value) + 1;
    }

    function decreaseQty(button) {
        const input = button.parentElement.querySelector('input[type="number"]');
        if (parseInt(input.value) > 1) {
            input.value = parseInt(input.value) - 1;
        }
    }
</script>

</body>
</html>
