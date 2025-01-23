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
            <img src="<%=user != null && user.getImage() != null ? "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(user.getImage()) : "default-profile.jpg" %>" alt="User Profile Image"  alt="Profile" class="profile-avatar">
            <div class="profile-details">
                <h1 class="mb-1"><%= user != null ? user.getFullName() : "Unknown" %></h1>
                <p class="mb-4">System Administrator</p>
            </div>
        </div>
    </div>

    <!-- Change Admin Details Section -->
    <div class="profile-section">
        <h2 class="section-title">Change Admin Details</h2>
        <form id="changeDetailsForm">
            <div class="mb-3">
                <label for="changePhoto" class="form-label">Change Photo</label>
                <input type="file" id="changePhoto" class="form-control">
            </div>
            <div class="mb-3">
                <label for="adminFullName" class="form-label">Full Name</label>
                <input type="text" id="adminFullName" class="form-control" placeholder="Enter your full name"
                       value="<%= user != null ? user.getFullName() : "" %>">
            </div>
            <div class="mb-3">
                <label for="adminEmail" class="form-label">Email</label>
                <input type="email" id="adminEmail" class="form-control" placeholder="Enter your email"
                       value="<%= user != null ? user.getEmail() : "" %>">
            </div>
            <div class="mb-3">
                <label for="adminPhone" class="form-label">Phone</label>
                <input type="text" id="adminPhone" class="form-control" placeholder="Enter your phone number"
                       value="<%= user != null ? user.getPhoneNumber() : "" %>">
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>

    <!-- Change Username Section -->
    <div class="profile-section">
        <h2 class="section-title">Change Username</h2>
        <form id="changeUsernameForm">
            <div class="mb-3">
                <label for="adminUsername" class="form-label">Username</label>
                <input type="text" id="adminUsername" class="form-control" placeholder="Enter your username"
                       value="<%= user != null ? user.getUsername() : "" %>">
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
                <input type="password" id="currentPassword" class="form-control"
                       placeholder="Enter your current password">
            </div>
            <div class="mb-3">
                <label for="newPassword" class="form-label">New Password</label>
                <input type="password" id="newPassword" class="form-control" placeholder="Enter your new password">
            </div>
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                <input type="password" id="confirmPassword" class="form-control"
                       placeholder="Re-enter your new password">
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-primary">Update Password</button>
            </div>
        </form>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>
</body>
</html>
