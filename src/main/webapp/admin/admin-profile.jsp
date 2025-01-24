<%@ page import="dto.UserDTO" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-profile.css">
</head>
<body>
<%@include file="/includes/admin-header.jsp" %>

<%
    UserDTO user = (UserDTO) request.getAttribute("user");
%>

<div class="container py-5">
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="profile-cover"></div>
        <div class="profile-info">
            <img src="<%=user != null && user.getImage() != null ? "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(user.getImage()) : "default-profile.jpg" %>" alt="User Profile Image"  alt="Profile" class="profile-avatar-main">
            <div class="profile-details">
                <h1 class="mb-1"><%= user != null ? user.getFullName() : "Unknown" %></h1>
                <p class="mb-4">System Administrator</p>
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

    <!-- Change Admin Details Section -->
    <div class="profile-section">
        <h2 class="section-title">Change Admin Details</h2>
        <form action="profile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="profile-info-update">
            <!-- Profile Picture Section -->
            <div class="mb-3 text-center">
                <!-- Initial profile image -->
                <img id="profileImagePreview" src="${pageContext.request.contextPath}/assets/images/Profile-image.jpg"
                     alt="Profile" class="profile-avatar">
            </div>
            <div class="mb-3">
                <label for="changePhoto" class="form-label">Change Photo</label>
                <input type="file" id="changePhoto" name="image" class="form-control" required>
                <div id="image-alert" class="alert d-none"></div>
            </div>
            <div class="mb-3">
                <label for="adminFullName" class="form-label">Full Name</label>
                <input type="text" id="adminFullName" name="fullName" class="form-control" placeholder="Enter your full name"
                       value="<%= user != null ? user.getFullName() : "" %>" required>
            </div>
            <div class="mb-3">
                <label for="adminEmail" class="form-label">Email</label>
                <input type="email" id="adminEmail" name="email" class="form-control" placeholder="Enter your email"
                       value="<%= user != null ? user.getEmail() : "" %>" required>
            </div>
            <div class="mb-3">
                <label for="adminAddress" class="form-label">Address</label>
                <input type="text" id="adminAddress" name="address" class="form-control" placeholder="Enter your address"
                       value="<%= user != null ? user.getAddress() : "" %>" required>
            </div>
            <div class="mb-3">
                <label for="adminPhone" class="form-label">Phone</label>
                <input type="text" id="adminPhone" name="phone" class="form-control" placeholder="Enter your phone number"
                       value="<%= user != null ? user.getPhoneNumber() : "" %>" required>
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>

    <!-- Change Username Section -->
    <div class="profile-section">
        <h2 class="section-title">Change Username</h2>
        <form action="profile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="profile-username-update">
            <div class="mb-3">
                <label for="adminUsername" class="form-label">Username</label>
                <input type="text" name="username" id="adminUsername" class="form-control" placeholder="Enter your username"
                       value="<%= user != null ? user.getUsername() : "" %>" required>
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
                <input type="password" name="currentPassword" id="currentPassword" class="form-control"
                       placeholder="Enter your current password" required>
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
                <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"
                       placeholder="Re-enter your new password" required>
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

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
</body>
</html>
