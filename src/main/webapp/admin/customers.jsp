<%@ page import="lk.ijse.ecommercewebapplication.dto.UserDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
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

    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Customers</div>
            <div class="stat-value">${totalCustomers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Customers</div>
            <div class="stat-value">${activeCustomers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Inactive Customers</div>
            <div class="stat-value">${inactiveCustomers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">New This Month</div>
            <div class="stat-value">${newCustomers}</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-bar">
            <select class="search-select" id="searchType">
                <option value="name">Search by Name</option>
                <option value="email">Search by Email</option>
                <option value="phone">Search by Phone</option>
            </select>
            <input type="text" id="searchInput" class="search-input" placeholder="Search customers...">
            <button class="search-btn" id="searchBtn">Search</button>
        </div>
        <div class="filter-group ms-2">
            <select class="filter-select" id="statusFilter">
                <option value="all">All Status</option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
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
                <tbody id="customerTableBody">
                <%
                    List<UserDTO> customerList = (List<UserDTO>) request.getAttribute("customerList");
                    if (customerList != null && !customerList.isEmpty()) {
                        for (UserDTO customer : customerList) {
                            String base64Image = customer.getImage() != null
                                    ? Base64.getEncoder().encodeToString(customer.getImage())
                                    : null;
                %>
                <tr>
                    <td>
                        <div class="d-flex align-items-center">
                            <% if (base64Image != null) { %>
                            <img src="data:image/png;base64,<%= base64Image %>"
                                 class="customer-avatar" alt="Customer">
                            <% } else { %>
                            <div class="customer-avatar-placeholder">
                                <%= customer.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                            <% } %>
                            <%
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy");
                                String year = sdf.format(customer.getDate());
                            %>
                            <div class="ms-3">
                                <div class="fw-bold"><%= customer.getFullName() %></div>
                                <div class="text-warning small">Member since <%= year %></div>
                            </div>
                        </div>
                    </td>
                    <td><%= customer.getEmail() %></td>
                    <td><%= customer.getPhoneNumber() %></td>
                    <td><%= customer.getOrderCount() %></td>
                    <td>
                        <span class="badge <%= "Active".equals(customer.getStatus()) ? "bg-success" : "bg-danger" %>">
                            <%= customer.getStatus() %>
                        </span>
                    </td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary me-2"
                                onclick="viewCustomer(<%= customer.getUserId() %>)">
                            <i class="fas fa-eye"></i>
                        </button>
                        <% if ("Active".equals(customer.getStatus())) { %>
                        <button class="btn btn-sm btn-outline-danger"
                                onclick="updateStatus(<%= customer.getUserId() %>, 'Inactive')">
                            <i class="fas fa-times"></i>
                        </button>
                        <% } else { %>
                        <button class="btn btn-sm btn-outline-success"
                                onclick="updateStatus(<%= customer.getUserId() %>, 'Active')">
                            <i class="fas fa-check"></i>
                        </button>
                        <% } %>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center">No customers found.</td>
                </tr>
                <%
                    }
                %>
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
                            <img id="customerAvatar" src="" class="profile-avatar" alt="Customer">
                            <div class="profile-info">
                                <h4 id="customerName" class="mb-1"></h4>
                                <p id="memberSince" class="text-warning mb-0"></p>
                            </div>
                        </div>
                        <div class="profile-details mt-4">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email</label>
                                    <div id="customerEmail" class="form-control-static"></div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone</label>
                                    <div id="customerPhone" class="form-control-static"></div>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Address</label>
                                    <div id="customerAddress" class="form-control-static"></div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Total Orders</label>
                                    <div id="totalOrders" class="form-control-static"></div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Status</label>
                                    <div id="customerStatus" class="form-control-static"></div>
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
                                    <tbody id="recentOrdersBody">
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
    // Search and filter functionality
    function searchCustomers() {
        const searchType = $('#searchType').val();
        const searchTerm = $('#searchInput').val();
        const status = $('#statusFilter').val();

        $.ajax({
            url: '${pageContext.request.contextPath}/customer',
            type: 'GET',
            data: {
                action: 'search',
                searchType: searchType,
                searchTerm: searchTerm,
                status: status
            },
            success: function(customers) {
                $('#customerTableBody').empty(); // Clear existing rows

                if (customers && customers.length > 0) {
                    customers.forEach(function(customer) {
                        var row = '<tr>' +
                            '<td>' +
                            '<div class="d-flex align-items-center">';

                        if (customer.image) {
                            row += '<img src="data:image/png;base64,' + customer.image + '" class="customer-avatar" alt="Customer">';
                        } else {
                            row += '<div class="customer-avatar-placeholder">' + customer.fullName.charAt(0).toUpperCase() + '</div>';
                        }

                        row +=     '<div class="ms-3">' +
                            '<div class="fw-bold">' + customer.fullName + '</div>' +
                            '<div class="text-warning small">Member since ' + customer.date + '</div>' +
                            '</div>' +
                            '</div>' +
                            '</td>' +
                            '<td>' + customer.email + '</td>' +
                            '<td>' + customer.phoneNumber + '</td>' +
                            '<td>' + customer.orderCount + '</td>' +
                            '<td>' +
                            '<span class="badge ' + (customer.status === 'Active' ? 'bg-success' : 'bg-danger') + '">' +
                            customer.status +
                            '</span>' +
                            '</td>' +
                            '<td class="text-end">' +
                            '<button class="btn btn-sm btn-outline-primary me-2" onclick="viewCustomer(' + customer.userId + ')">' +
                            '<i class="fas fa-eye"></i>' +
                            '</button>';

                        if (customer.status === 'Active') {
                            row += '<button class="btn btn-sm btn-outline-danger" onclick="updateStatus(' + customer.userId + ', \'Inactive\')">' +
                                '<i class="fas fa-times"></i>' +
                                '</button>';
                        } else {
                            row += '<button class="btn btn-sm btn-outline-success" onclick="updateStatus(' + customer.userId + ', \'Active\')">' +
                                '<i class="fas fa-check"></i>' +
                                '</button>';
                        }

                        row +=     '</td>' +
                            '</tr>';

                        $('#customerTableBody').append(row); // Append row to the table body
                    });
                } else {
                    $('#customerTableBody').append('<tr><td colspan="6" class="text-center">No customers found.</td></tr>');
                }
            },
            error: function() {
                alert('Error searching customers');
            }
        });
    }

    $('#searchBtn').click(searchCustomers);
    $('#statusFilter').change(searchCustomers);

    // View customer details
    function viewCustomer(userId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/customer',
            type: 'GET',
            data: {
                action: 'view',
                userId: userId
            },
            success: function(response) {
                const customer = response.customer;
                const orders = response.orders;

                // Update customer details
                $('#customerAvatar').attr('src', customer.image
                    ? 'data:image/png;base64,' + customer.image
                    : '${pageContext.request.contextPath}/assets/images/default-avatar.png');

                $('#customerName').text(customer.fullName);
                $('#memberSince').text('Member since ' + customer.date);
                $('#customerEmail').text(customer.email);
                $('#customerPhone').text(customer.phoneNumber);
                $('#customerAddress').text(customer.address);
                $('#totalOrders').text(customer.orderCount);
                $('#customerStatus').html(
                    '<span class="badge ' + (customer.status === 'Active' ? 'bg-success' : 'bg-danger') + '">' +
                    customer.status +
                    '</span>'
                );

                // Update recent orders
                $('#recentOrdersBody').empty();
                if (orders && orders.length > 0) {
                    orders.forEach(function(order) {
                        var row = '<tr>' +
                            '<td>' + order.orderId + '</td>' +
                            '<td>' + order.date + '</td>' +
                            '<td>$' + order.total.toFixed(2) + '</td>' +
                            '<td>' +
                            '<span class="badge ' + (order.status === 'Completed' ? 'bg-success' : 'bg-warning') + '">' +
                            order.status +
                            '</span>' +
                            '</td>' +
                            '</tr>';

                        $('#recentOrdersBody').append(row);
                    });

                } else {
                    $('#recentOrdersBody').append('<tr><td colspan="4" class="text-center">No orders found.</td></tr>');
                }

                $('#viewCustomerModal').modal('show');
            },
            error: function() {
                alert('Error fetching customer details');
            }
        });
    }

    // Update customer status
    function updateStatus(userId, newStatus) {
        $.ajax({
            url: '${pageContext.request.contextPath}/customer',
            type: 'POST',
            data: {
                action: 'update-status',
                userId: userId,
                status: newStatus
            },
            success: function(response) {
                if (response.status === 'success') {
                    location.reload();
                } else {
                    alert('Error updating customer status');
                }
            },
            error: function() {
                alert('Error updating customer status');
            }
        });
    }
</script>

</body>
</html>