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
            <div class="stat-value">3,567</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Pending Orders</div>
            <div class="stat-value">45</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Today's Revenue</div>
            <div class="stat-value">$12,845</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Monthly Revenue</div>
            <div class="stat-value">$158,962</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-bar">
            <select class="search-select">
                <option value="order">Order ID</option>
                <option value="customer">Customer Name</option>
                <option value="status">Status</option>
            </select>
            <input type="text" class="search-input" placeholder="Search orders...">
            <button class="search-btn">Search</button>
        </div>
        <div class="filter-group">
            <select class="filter-select">
                <option value="all">All Status</option>
                <option value="pending">Pending</option>
                <option value="processing">Processing</option>
                <option value="shipped">Shipped</option>
                <option value="delivered">Delivered</option>
                <option value="cancelled">Cancelled</option>
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
                    <th>Payment</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>#ORD-12345</td>
                    <td>
                        <div class="d-flex align-items-center">
                            <img src="https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80"
                                 class="customer-avatar" alt="Customer">
                            <div class="ms-3">John Doe</div>
                        </div>
                    </td>
                    <td>2024-01-15</td>
                    <td>$999.99</td>
                    <td><span class="badge bg-warning">Pending</span></td>
                    <td><span class="badge bg-success">Paid</span></td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="viewOrder('12345')">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-warning me-2" onclick="changeOrderStatus('12345')"
                                title="Change Status">
                            <i class="fas fa-exchange-alt"></i>
                        </button>
                    </td>
                </tr>
                <!-- Add more order rows as needed -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- View Order Modal -->
    <div class="modal fade" id="viewOrderModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Order Details #ORD-12345</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="order-info mb-4">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-secondary mb-3">Customer Information</h6>
                                <div class="customer-details">
                                    <p class="mb-1">John Doe</p>
                                    <p class="mb-1">john.doe@example.com</p>
                                    <p class="mb-1">+1 234-567-8900</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-secondary mb-3">Shipping Address</h6>
                                <div class="shipping-details">
                                    <p class="mb-1">123 Main Street</p>
                                    <p class="mb-1">Apt 4B</p>
                                    <p class="mb-1">New York, NY 10001</p>
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
                                <tr>
                                    <td>Gaming PC Pro</td>
                                    <td>1</td>
                                    <td>$999.99</td>
                                    <td>$999.99</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="order-summary mt-4">
                        <div class="row justify-content-end">
                            <div class="col-md-6">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Subtotal:</span>
                                    <span>$999.99</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span>$29.99</span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold mt-2 pt-2 border-top">
                                    <span>Total:</span>
                                    <span>$1,109.98</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Update Status</button>
                </div>
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
                            <span class="badge bg-warning">Pending</span>
                        </div>
                        <label class="form-label">New Status</label>
                        <select class="form-select bg-dark border-secondary text-white">
                            <option value="pending">Pending</option>
                            <option value="processing">Processing</option>
                            <option value="shipped">Shipped</option>
                            <option value="delivered">Delivered</option>
                            <option value="cancelled">Cancelled</option>
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
                <button type="button" class="btn btn-primary">Update Status</button>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>

<script>
    function viewOrder(id) {
        $('#viewOrderModal').modal('show');
    }
    function changeOrderStatus(orderId) {
        // Update current status badge in modal
        $('#changeStatusModal').modal('show');
    }

    // Initialize tooltips and popovers
    $(function () {
        $('[data-bs-toggle="tooltip"]').tooltip();
        $('[data-bs-toggle="popover"]').popover();
    });
</script>
</body>
</html>
