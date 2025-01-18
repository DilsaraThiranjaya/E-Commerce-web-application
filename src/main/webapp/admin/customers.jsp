<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customers.css">
</head>
<body>
<%@include file="/includes/admin-header.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="text-white">Customer Management</h1>
    </div>

    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Customers</div>
            <div class="stat-value">1,248</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Customers</div>
            <div class="stat-value">1,186</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Inactive Customers</div>
            <div class="stat-value">421</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">New This Month</div>
            <div class="stat-value">124</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-bar">
            <select class="search-select">
                <option value="name">Search by Name</option>
                <option value="email">Search by Email</option>
                <option value="phone">Search by Phone</option>
            </select>
            <input type="text" class="search-input" placeholder="Search customers...">
            <button class="search-btn">Search</button>
        </div>
        <div class="filter-group">
            <select class="filter-select">
                <option value="all">All Status</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>
        </div>
    </div>

    <!-- Customers Table -->
    <div class="card bg-dark-secondary">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0">
                <thead>
                <tr>
                    <th>Customer</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Orders</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>
                        <div class="d-flex align-items-center">
                            <img src="https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80"
                                 class="customer-avatar" alt="Customer">
                            <div class="ms-3">
                                <div class="fw-bold">John Doe</div>
                                <div class="text-warning small">Member since Jan 2023</div>
                            </div>
                        </div>
                    </td>
                    <td>john.doe@example.com</td>
                    <td>+1 234-567-8900</td>
                    <td>12</td>
                    <td><span class="badge bg-success">Active</span></td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="viewCustomer(1)">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-success me-2">
                            <i class="fas fa-check"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger">
                            <i class="fas fa-times"></i>
                        </button>
                    </td>
                </tr>
                <!-- Add more customer rows as needed -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- View Customer Modal -->
    <div class="modal fade" id="viewCustomerModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Customer Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="customer-profile">
                        <div class="profile-header">
                            <img src="https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80"
                                 class="profile-avatar" alt="Customer">
                            <div class="profile-info">
                                <h4 class="mb-1">John Doe</h4>
                                <p class="text-warning mb-0">Member since Jan 2023</p>
                            </div>
                        </div>
                        <div class="profile-details mt-4">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email</label>
                                    <div class="form-control-static">john.doe@example.com</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone</label>
                                    <div class="form-control-static">+1 234-567-8900</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Total Orders</label>
                                    <div class="form-control-static">12</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Total Spent</label>
                                    <div class="form-control-static">$2,456.00</div>
                                </div>
                            </div>
                            <div class="recent-orders mt-4">
                                <h5 class="mb-3">Recent Orders</h5>
                                <table class="table table-dark table-hover">
                                    <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Date</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>#12345</td>
                                        <td>2023-12-01</td>
                                        <td>$299.99</td>
                                        <td><span class="badge bg-success">Completed</span></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>

<script>
    function viewCustomer(id) {
        $('#viewCustomerModal').modal('show');
    }

    $(function () {
        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>
</body>
</html>
