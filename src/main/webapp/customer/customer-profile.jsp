<%@ page import="dto.UserDTO" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="dto.OrderDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-profile.css">
</head>
<body>
<%@include file="/includes/customer-header.jsp" %>

<%
    UserDTO user = (UserDTO) request.getAttribute("user");
%>

<div class="container py-5">
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="profile-cover"></div>
        <div class="profile-info">
            <img src="<%=user != null && user.getImage() != null ? "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(user.getImage()) : "default-profile.jpg" %>" alt="User Profile Image" alt="Profile" class="profile-avatar-main">
            <div class="profile-details">
                <h1 class="mb-1"><%= user != null ? user.getFullName() : "Unknown" %></h1>
                <div class="profile-actions">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                        <i class="fas fa-edit me-2"></i>Edit Profile
                    </button>
                </div>
            </div>
        </div>
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


    <!-- Profile Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-title">Total Orders</div>
            <div class="stat-value">${totalOrders != null ? totalOrders : "Not available"}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Orders of this Month</div>
            <div class="stat-value">${ordersCurrentMonth != null ? ordersCurrentMonth : "Not available"}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Total Spent</div>
            <div class="stat-value">${totalSpend != null ? totalSpend : "Not available"}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Member Since</div>

            <%
                LocalDateTime dateTime = user.getDate().toLocalDateTime();
                String year = String.valueOf(dateTime.getYear());
            %>

            <div class="stat-value"><%= year%></div>
        </div>
    </div>

    <!-- Profile Content -->
    <div class="profile-content">
        <!-- Left Column -->
        <div class="profile-sidebar">
            <div class="profile-section">
                <h3 class="section-title">Personal Information</h3>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <div class="form-control"><%= user != null ? user.getEmail() : "" %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <div class="form-control"><%= user != null ? user.getPhoneNumber() : "" %></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <div class="form-control" style="height: 100px"><%= user != null ? user.getAddress() : "" %></div>
                </div>
            </div>
        </div>

        <!-- Right Column -->
        <div class="profile-section">
            <h3 class="section-title">Recent Orders</h3>
            <div class="table-responsive" style="overflow-y: auto;">
                <table class="table table-dark table-hover">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
                        if (orderList != null && !orderList.isEmpty()) {
                            for (OrderDTO order : orderList) {
                    %>
                    <tr>
                        <td><%= order.getOrderId() %></td>
                        <td><%= order.getDate() %></td>
                        <td>Rs. <%= order.getSubTotal().add(order.getShippingCost()) %></td>
                        <td>
                            <% if ("Completed".equals(order.getStatus())) { %>
                            <span class="badge bg-success">Delivered</span>
                            <% } else if ("Pending".equals(order.getStatus())) { %>
                            <span class="badge bg-warning">Pending</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="4">No orders found.</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Change Username Section -->
        <div class="profile-section">
            <h2 class="section-title">Change Username</h2>
            <form action="profile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="profile-username-update">
                <div class="mb-3">
                    <label for="adminUsername" class="form-label">Username</label>
                    <input type="text" name="username" id="adminUsername" class="form-control" placeholder="Enter your username" value="<%= user != null ? user.getUsername() : "" %>" required>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-primary">Update Username</button>
                </div>
            </form>
        </div>

        <!-- Change Password Section -->
        <div class="profile-section">
            <h2 class="section-title">Change Password</h2>
            <form action="profile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="profile-password-update">
                <div class="mb-3">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <div class="input-group">
                    <input type="password" name="currentPassword" id="currentPassword" class="form-control" placeholder="Enter your current password" required>
                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="#currentPassword">
                        <i class="bi bi-eye"></i>
                    </button>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <div class="input-group">
                    <input type="password" name="newPassword" id="newPassword" class="form-control" placeholder="Enter your new password" required>
                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="#newPassword">
                        <i class="bi bi-eye"></i>
                    </button>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <div class="input-group">
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Re-enter your new password" required>
                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="#confirmPassword">
                        <i class="bi bi-eye"></i>
                    </button>
                    </div>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-primary">Update Password</button>
                </div>
            </form>
        </div>
    </div>
</div>
</div>

<!-- Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark text-light">
            <form action="profile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="profile-info-update">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Profile Picture Section -->
                    <div class="mb-4 text-center">
                        <!-- Initial profile image -->
                        <img id="profileImagePreview" src="${pageContext.request.contextPath}/assets/images/Profile-image.jpg"
                             alt="Profile" class="profile-avatar">
                    </div>
                    <div class="row mb-3">
                        <div class="col-12">
                            <div class="mb-3">
                                <label class="form-label">Change Photo</label>
                                <!-- File input to select image -->
                                <input type="file" class="form-control bg-dark border-secondary text-white" id="changePhoto" name="image" required>
                                <div id="image-alert" class="alert d-none"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="fullName" id="fullName" placeholder="Enter your full name" value="<%= user != null ? user.getFullName() : "" %>" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" value="<%= user != null ? user.getEmail() : "" %>" required>
                            </div>
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="row mb-3">
                        <div class="col-12">
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <input type="text" class="form-control" id="address" name="address" placeholder="Enter your address" value="<%= user != null ? user.getAddress() : "" %>" required>
                            </div>
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="Enter your phone number" value="<%= user != null ? user.getPhoneNumber() : "" %>" required>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>

        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
</body>
</html>
