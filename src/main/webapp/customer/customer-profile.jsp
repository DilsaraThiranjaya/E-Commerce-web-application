<%@ page import="dto.UserDTO" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.time.LocalDateTime" %>
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
            <img src="<%=user != null && user.getImage() != null ? "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(user.getImage()) : "default-profile.jpg" %>" alt="User Profile Image" alt="Profile" class="profile-avatar">
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
            <div class="stat-value">48</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Total Spent</div>
            <div class="stat-value">$8.5k</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Reviews</div>
            <div class="stat-value">12</div>
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
            <div class="table-responsive">
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
                    <tr>
                        <td>#ORD-12345</td>
                        <td>2024-01-15</td>
                        <td>$999.99</td>
                        <td><span class="badge bg-success">Delivered</span></td>
                    </tr>
                    <tr>
                        <td>#ORD-12344</td>
                        <td>2024-01-10</td>
                        <td>$249.99</td>
                        <td><span class="badge bg-warning">In Transit</span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Change Username Section -->
        <div class="profile-section">
            <h2 class="section-title">Change Username</h2>
            <form id="changeUsernameForm">
                <div class="mb-3">
                    <label for="adminUsername" class="form-label">Username</label>
                    <input type="text" id="adminUsername" class="form-control" placeholder="Enter your username" value="<%= user != null ? user.getUsername() : "" %>">
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-primary">Update Username</button>
                </div>
            </form>
        </div>

        <!-- Change Password Section -->
        <div class="profile-section">
            <h2 class="section-title">Change Password</h2>
            <form id="changePasswordForm">
                <div class="mb-3">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <input type="password" id="currentPassword" class="form-control" placeholder="Enter your current password">
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" id="newPassword" class="form-control" placeholder="Enter your new password">
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" id="confirmPassword" class="form-control" placeholder="Re-enter your new password">
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
                                <input type="file" class="form-control bg-dark border-secondary text-white" id="changePhoto" name="image">
                                <div id="image-alert" class="alert d-none"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="fullName" id="fullName" placeholder="Enter your full name" value="<%= user != null ? user.getFullName() : "" %>">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" value="<%= user != null ? user.getEmail() : "" %>">
                            </div>
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="row mb-3">
                        <div class="col-12">
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <input type="text" class="form-control" id="address" name="address" placeholder="Enter your address" value="<%= user != null ? user.getAddress() : "" %>">
                            </div>
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="Enter your phone number" value="<%= user != null ? user.getPhoneNumber() : "" %>">
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
