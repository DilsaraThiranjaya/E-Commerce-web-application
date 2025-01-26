<%@ page import="lk.ijse.ecommercewebapplication.dto.OrderDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css">
</head>
<body>
<%@include file="/includes/admin-header.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="text-white">Order Management</h1>
    </div>

    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Orders</div>
            <div class="stat-value"><%=request.getAttribute("totalOrders")%></div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Pending Orders</div>
            <div class="stat-value"><%=request.getAttribute("pendingOrders")%></div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Today's Revenue</div>
            <div class="stat-value">Rs. <%=request.getAttribute("todayRevenue")%></div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Monthly Revenue</div>
            <div class="stat-value">Rs. <%=request.getAttribute("monthlyRevenue")%></div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-bar">
            <select class="search-select">
                <option value="order">Order ID</option>
                <option value="customer">Customer Name</option>
            </select>
            <input type="text" class="search-input" placeholder="Search orders...">
            <button class="search-btn">Search</button>
        </div>
        <div class="filter-group">
            <select class="filter-select">
                <option value="all">Status</option>
                <option value="Pending">Pending</option>
                <option value="Completed">Completed</option>
            </select>
            <input type="date" class="date-filter" title="Filter by date">
        </div>
    </div>

    <!-- Orders Table -->
    <div class="card bg-dark-secondary">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0">
                <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Payment Method</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
                    if (orderList != null && !orderList.isEmpty()) {
                        for (OrderDTO order : orderList) {
                            String statusClass = "Pending".equals(order.getStatus()) ? "warning" : "success";
                            String paymentClass = "COD".equals(order.getPaymentMethod()) ? "success" : "info";
                            String customerImage = order.getCustomerImage() != null ?
                                    Base64.getEncoder().encodeToString(order.getCustomerImage()) : null;
                %>
                <tr>
                    <td><%=order.getOrderId()%></td>
                    <td>
                        <div class="d-flex align-items-center">
                            <% if (customerImage != null) { %>
                            <img src="data:image/jpeg;base64,<%=customerImage%>"
                                 class="customer-avatar" alt="Customer">
                            <% } %>
                            <div class="ms-3"><%=order.getCustomerName()%></div>
                        </div>
                    </td>
                    <td><%=order.getDate()%></td>
                    <td>Rs. <%=order.getSubTotal().add(order.getShippingCost())%></td>
                    <td><span class="badge bg-<%=statusClass%>"><%=order.getStatus()%></span></td>
                    <td><span class="badge bg-<%=paymentClass%>"><%=order.getPaymentMethod()%></span></td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="viewOrder('<%=order.getOrderId()%>')">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-warning me-2"
                                onclick="changeOrderStatus('<%=order.getOrderId()%>', '<%=order.getStatus()%>')"
                                title="Change Status">
                            <i class="fas fa-exchange-alt"></i>
                        </button>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7" class="text-center">No orders available.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- View Order Modal -->
    <div class="modal fade" id="viewOrderModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Order Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="order-info mb-4">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-secondary mb-3">Customer Information</h6>
                                <div class="customer-details">
                                    <!-- Populated by JavaScript -->
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-secondary mb-3">Shipping Address</h6>
                                <div class="shipping-details">
                                    <!-- Populated by JavaScript -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="order-items">
                        <h6 class="text-secondary mb-3">Order Items</h6>
                        <div class="table-responsive">
                            <table class="table table-dark table-hover">
                                <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                </tr>
                                </thead>
                                <tbody>
                                <!-- Populated by JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="order-summary mt-4">
                        <div class="row justify-content-end">
                            <div class="col-md-6">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Subtotal:</span>
                                    <span id="orderSubtotal">$0.00</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span id="orderShipping">$0.00</span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold mt-2 pt-2 border-top">
                                    <span>Total:</span>
                                    <span id="orderTotal">$0.00</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Order Status Change Modal -->
    <div class="modal fade" id="changeStatusModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Update Order Status</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="updateStatusForm">
                        <div class="mb-4">
                            <label class="form-label">Current Status</label>
                            <div class="current-status mb-3">
                                <span id="currentStatusBadge" class="badge"></span>
                            </div>
                            <label class="form-label">New Status</label>
                            <select class="form-select bg-dark border-secondary text-white" id="newStatus">
                                <option value="Pending">Pending</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Notify Customer</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="notifyCustomer" checked>
                                <label class="form-check-label" for="notifyCustomer">
                                    Send email notification to customer
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="updateStatusBtn">Update Status</button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>
<script>
    // Search orders
    $('.search-btn').click(function() {
        const searchType = $('.search-select').val();
        const searchValue = $('.search-input').val();
        const status = $('.filter-select').val();
        const date = $('.date-filter').val();

        $.ajax({
            url: '/E_Commerce_web_application_war_exploded/orders',
            type: 'GET',
            data: {
                searchType: searchType,
                searchValue: searchValue,
                status: status,
                date: date
            },
            success: function(response) {
                location.reload();
            },
            error: function() {
                alert('Error searching orders.');
            }
        });
    });

    // View order details
    function viewOrder(orderId) {
        $.ajax({
            url: '/E_Commerce_web_application_war_exploded/orders',
            type: 'GET',
            data: {
                action: 'view',
                orderId: orderId
            },
            success: function(order) {
                // Populate modal with order details
                $('.modal-title').text('Order Details #' + order.orderId);
                $('.customer-details').html(`
                <p class="mb-1">${order.customerName}</p>
                <p class="mb-1">${order.email}</p>
                <p class="mb-1">${order.phone}</p>
            `);
                $('.shipping-details').html(`
                <p class="mb-1">${order.address}</p>
                <p class="mb-1">${order.city}</p>
                <p class="mb-1">${order.state} ${order.zipCode}</p>
            `);

                // Show the modal
                $('#viewOrderModal').modal('show');
            },
            error: function() {
                alert('Error loading order details.');
            }
        });
    }

    // Change order status
    function changeOrderStatus(orderId, currentStatus) {
        $('#currentStatusBadge')
            .removeClass('bg-warning bg-success')
            .addClass(currentStatus === 'Pending' ? 'bg-warning' : 'bg-success')
            .text(currentStatus);

        $('#newStatus').val(currentStatus);
        $('#changeStatusModal').data('orderId', orderId).modal('show');
    }

    // Update order status
    $('#updateStatusBtn').click(function() {
        const orderId = $('#changeStatusModal').data('orderId');
        const newStatus = $('#newStatus').val();
        const notifyCustomer = $('#notifyCustomer').is(':checked');

        $.ajax({
            url: '/E_Commerce_web_application_war_exploded/orders',
            type: 'PUT',
            data: {
                orderId: orderId,
                status: newStatus,
                notify: notifyCustomer
            },
            success: function(response) {
                if (response.status === 'success') {
                    $('#changeStatusModal').modal('hide');
                    location.reload();
                } else {
                    alert('Error updating order status.');
                }
            },
            error: function() {
                alert('Error updating order status.');
            }
        });
    });
</script>
</body>
</html>