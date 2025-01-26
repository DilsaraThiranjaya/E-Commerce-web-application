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
                                    <span id="orderSubtotal">Rs. 0.00</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span id="orderShipping">Rs. 0.00</span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold mt-2 pt-2 border-top">
                                    <span>Total:</span>
                                    <span id="orderTotal">Rs. 0.00</span>
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
    // Search and filter functionality
    document.addEventListener('DOMContentLoaded', function() {
        const searchSelect = document.querySelector('.search-select');
        const searchInput = document.querySelector('.search-input');
        const searchBtn = document.querySelector('.search-btn');
        const statusFilter = document.querySelector('.filter-select');
        const dateFilter = document.querySelector('.date-filter');

        function performSearch() {
            const searchType = searchSelect.value;
            const searchValue = searchInput.value;
            const status = statusFilter.value;
            const date = dateFilter.value;

            fetch('/E_Commerce_web_application_war_exploded/order?action=search&searchType='+searchType+'&searchValue='+searchValue+'&status='+status+'&date='+date)
                .then(response => response.json())
                .then(data => updateOrdersTable(data))
                .catch(error => console.error('Error:', error));
        }

        searchBtn.addEventListener('click', performSearch);
        statusFilter.addEventListener('change', performSearch);
        dateFilter.addEventListener('change', performSearch);

        function updateOrdersTable(orders) {
            const tbody = document.querySelector('tbody');
            tbody.innerHTML = '';

            if (orders.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center">No orders found.</td></tr>';
                return;
            }

            orders.forEach(order => {
                const statusClass = order.status === 'Pending' ? 'warning' : 'success';
                const paymentClass = order.paymentMethod === 'COD' ? 'success' : 'info';

                const row =
                    '<tr>' +
                    '<td>' + order.orderId + '</td>' +
                    '<td>' +
                    '<div class="d-flex align-items-center">' +
                    (order.customerImage ?
                        '<img src="data:image/jpeg;base64,' + order.customerImage + '" ' +
                        'class="customer-avatar" alt="Customer">' : '') +
                    '<div class="ms-3">' + order.customerName + '</div>' +
                    '</div>' +
                    '</td>' +
                    '<td>' + order.date + '</td>' +
                    '<td>Rs. ' + order.total + '</td>' +
                    '<td><span class="badge bg-' + statusClass + '">' + order.status + '</span></td>' +
                    '<td><span class="badge bg-' + paymentClass + '">' + order.paymentMethod + '</span></td>' +
                    '<td class="text-end">' +
                    '<button class="btn btn-sm btn-outline-primary me-2" onclick="viewOrder(\'' + order.orderId + '\')">' +
                    '<i class="fas fa-eye"></i>' +
                    '</button>' +
                    '<button class="btn btn-sm btn-outline-warning me-2" ' +
                    'onclick="changeOrderStatus(\'' + order.orderId + '\', \'' + order.status + '\')" ' +
                    'title="Change Status">' +
                    '<i class="fas fa-exchange-alt"></i>' +
                    '</button>' +
                    '</td>' +
                    '</tr>';

                tbody.innerHTML += row;
            });
        }
    });

    // View order details
    function viewOrder(orderId) {
        fetch('/E_Commerce_web_application_war_exploded/order?action=view&orderId='+orderId)
            .then(response => response.json())
            .then(data => {
                // Update customer information
                document.querySelector('.customer-details').innerHTML =
                    '<p><strong>Name:</strong> ' + data.customerName + '</p>' +
                    '<p><strong>Email:</strong> ' + data.customerEmail + '</p>' +
                    '<p><strong>Phone:</strong> ' + data.customerPhone + '</p>';


                // Update shipping address
                document.querySelector('.shipping-details').innerHTML =
                    '<p>' + data.address + '</p>' +
                    '<p>' + data.city + ', ' + data.state + ' ' + data.zipCode + '</p>';


                // Update order items
                const tbody = document.querySelector('#viewOrderModal .order-items tbody');
                tbody.innerHTML = '';
                data.items.forEach(function(item) {
                    tbody.innerHTML +=
                        '<tr>' +
                        '<td>' + item.productName + '</td>' +
                        '<td>' + item.quantity + '</td>' +
                        '<td>Rs. ' + item.unitPrice + '</td>' +
                        '<td>Rs. ' + (item.quantity * item.unitPrice) + '</td>' +
                        '</tr>';
                });


                // Update order summary
                document.getElementById('orderSubtotal').textContent = 'Rs. ' + data.subTotal;
                document.getElementById('orderShipping').textContent = 'Rs. ' + data.shippingCost;
                document.getElementById('orderTotal').textContent = 'Rs. ' + data.total;


                // Show the modal
                new bootstrap.Modal(document.getElementById('viewOrderModal')).show();
            })
            .catch(error => console.error('Error:', error));
    }

    // Change order status
    function changeOrderStatus(orderId, currentStatus) {
        const modal = document.getElementById('changeStatusModal');
        const statusBadge = document.getElementById('currentStatusBadge');
        const newStatusSelect = document.getElementById('newStatus');

        // Set current status badge
        statusBadge.className = 'badge bg-' + (currentStatus === 'Pending' ? 'warning' : 'success');
        statusBadge.textContent = currentStatus;

        // Set new status dropdown to exclude current status
        newStatusSelect.value = currentStatus === 'Pending' ? 'Completed' : 'Pending';

        // Show modal
        new bootstrap.Modal(modal).show();

        // Handle status update
        document.getElementById('updateStatusBtn').onclick = function() {
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('status', newStatusSelect.value);
            formData.append('notify', document.getElementById('notifyCustomer').checked);

            fetch('/E_Commerce_web_application_war_exploded/order', {
                method: 'PUT',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Failed to update order status');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while updating the order status');
                });
        };
    }
</script>
</body>
</html>