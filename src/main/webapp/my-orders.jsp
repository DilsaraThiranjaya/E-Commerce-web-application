<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/my-orders.css">
</head>
<body>
<%@include file="/includes/customer-header.jsp" %>

<div class="container py-5">
    <!-- Quick Stats -->
    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Orders</div>
            <div class="stat-value">12</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Orders</div>
            <div class="stat-value">2</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Total Spent</div>
            <div class="stat-value">$4,567</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Last Order</div>
            <div class="stat-value">Today</div>
        </div>
    </div>

    <!-- Orders List -->
    <div class="card bg-dark-secondary mb-4">
        <div class="card-body">
            <div class="accordion" id="ordersAccordion">
                <!-- Order Item -->
                <div class="accordion-item bg-transparent border-0 mb-3">
                    <div class="accordion-header">
                        <button class="accordion-button text-white collapsed" type="button"
                                data-bs-toggle="collapse" data-bs-target="#order1">
                            <div class="d-flex justify-content-between align-items-center w-100">
                                <div>
                                    <h6 class="mb-0">Order #12345</h6>
                                    <small class="text-secondary">January 15, 2024</small>
                                </div>
                                <div class="d-flex align-items-center gap-4">
                                    <span class="badge bg-warning">Processing</span>
                                    <span class="text-primary fw-bold me-2">$999.99</span>
                                </div>
                            </div>
                        </button>
                    </div>
                    <div id="order1" class="accordion-collapse collapse" data-bs-parent="#ordersAccordion">
                        <div class="accordion-body rounded-bottom">
                            <!-- Order Items -->
                            <div class="mb-4">
                                <h6 class="mb-3">Order Items</h6>
                                <div class="table-responsive">
                                    <table class="table table-dark table-hover">
                                        <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://images.unsplash.com/photo-1587202372634-32705e3bf49c?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80"
                                                         class="rounded me-3" style="width: 50px; height: 50px; object-fit: cover;" alt="Product">
                                                    <div>
                                                        <div class="fw-bold">Gaming PC Pro</div>
                                                        <small class="text-secondary">High-performance desktop</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>$999.99</td>
                                            <td>1</td>
                                            <td>$999.99</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Order Details -->
                            <div class="row g-4 order-details">
                                <div class="col-md-6">
                                    <div class="card h-100">
                                        <div class="card-body text-white">
                                            <h6 class="card-title mb-3">Shipping Address</h6>
                                            <p class="mb-1">John Doe</p>
                                            <p class="mb-1">123 Main Street</p>
                                            <p class="mb-1">Apt 4B</p>
                                            <p class="mb-0">New York, NY 10001</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card  h-100">
                                        <div class="card-body text-white">
                                            <h6 class="card-title mb-3">Order Summary</h6>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Subtotal</span>
                                                <span>$999.99</span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Shipping</span>
                                                <span>$29.99</span>
                                            </div>
                                            <hr class="border-secondary">
                                            <div class="d-flex justify-content-between">
                                                <span class="fw-bold">Total</span>
                                                <span class="text-primary fw-bold">$1,109.98</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add more order items here -->
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>

</body>
</html>
