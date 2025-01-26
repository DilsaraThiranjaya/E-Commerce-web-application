<%@ page import="lk.ijse.ecommercewebapplication.dto.OrderDTO" %>
<%@ page import="lk.ijse.ecommercewebapplication.dto.OrderDetailDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
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
            <div class="stat-value">${totalOrders}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Orders</div>
            <div class="stat-value">${activeOrders}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Total Spent</div>
            <div class="stat-value">Rs. ${totalSpent}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Last Order</div>
            <div class="stat-value">${lastOrderDate}</div>
        </div>
    </div>

    <!-- Orders List -->
    <div class="card bg-dark-secondary mb-4">
        <div class="card-body">
            <div class="accordion" id="ordersAccordion">
                <%
                    List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("orders");
                    if (orders != null && !orders.isEmpty()) {
                        for (OrderDTO order : orders) {
                %>
                <div class="accordion-item bg-transparent border-0 mb-3">
                    <div class="accordion-header">
                        <button class="accordion-button text-white collapsed" type="button"
                                data-bs-toggle="collapse" data-bs-target="#order<%=order.getOrderId()%>">
                            <div class="d-flex justify-content-between align-items-center w-100">
                                <div>
                                    <h6 class="mb-0">Order #<%=order.getOrderId()%></h6>
                                    <small class="text-secondary"><%=order.getDate()%></small>
                                </div>
                                <div class="d-flex align-items-center gap-4">
                                    <span class="badge <%="Pending".equals(order.getStatus()) ? "bg-warning" : "bg-success"%>">
                                        <%=order.getStatus()%>
                                    </span>
                                    <span class="text-primary fw-bold me-2">Rs. <%=order.getSubTotal().add(order.getShippingCost())%></span>
                                </div>
                            </div>
                        </button>
                    </div>
                    <div id="order<%=order.getOrderId()%>" class="accordion-collapse collapse" data-bs-parent="#ordersAccordion">
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
                                        <%
                                            for (OrderDetailDTO detail : order.getOrderDetails()) {
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div>
                                                        <div class="fw-bold"><%=detail.getProductName()%></div>
                                                        <small class="text-secondary">Item #<%=detail.getItemCode()%></small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>Rs. <%=detail.getUnitPrice()%></td>
                                            <td><%=detail.getQuantity()%></td>
                                            <td>Rs. <%=detail.getUnitPrice().multiply(new java.math.BigDecimal(detail.getQuantity()))%></td>
                                        </tr>
                                        <%
                                            }
                                        %>
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
                                            <p class="mb-1"><%=order.getCustomerName()%></p>
                                            <p class="mb-1"><%=order.getAddress()%></p>
                                            <p class="mb-1"><%=order.getCity()%>, <%=order.getState()%></p>
                                            <p class="mb-0"><%=order.getZipCode()%></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card h-100">
                                        <div class="card-body text-white">
                                            <h6 class="card-title mb-3">Order Summary</h6>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Subtotal</span>
                                                <span>Rs. <%=order.getSubTotal()%></span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Shipping</span>
                                                <span>Rs. <%=order.getShippingCost()%></span>
                                            </div>
                                            <hr class="border-secondary">
                                            <div class="d-flex justify-content-between">
                                                <span class="fw-bold">Total</span>
                                                <span class="text-primary fw-bold">Rs. <%=order.getSubTotal().add(order.getShippingCost())%></span>
                                            </div>
                                            <div class="mt-3">
                                                <small class="text-secondary">Payment Method: <%=order.getPaymentMethod()%></small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="text-center text-white py-5">
                    <h4>No orders found</h4>
                    <p class="text-secondary">You haven't placed any orders yet.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-3">Start Shopping</a>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>

</body>
</html>