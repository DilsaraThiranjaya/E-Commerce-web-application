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

<div class="container py-5">
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="profile-cover"></div>
        <div class="profile-info">
            <img src="https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&auto=format&fit=crop&w=120&q=80"
                 alt="Profile" class="profile-avatar">
            <div class="profile-details">
                <h1 class="mb-1">John Doe</h1>
                <p class="mb-3">San Francisco, CA</p>
                <div class="profile-actions">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                        <i class="fas fa-edit me-2"></i>Edit Profile
                    </button>
                </div>
            </div>
        </div>
    </div>

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
            <div class="stat-value">2022</div>
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
                    <div class="form-control">john.doe@example.com</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <div class="form-control">+1 (234) 567-8900</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Location</label>
                    <div class="form-control">San Francisco, CA</div>
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
                    <input type="text" id="adminUsername" class="form-control" placeholder="Enter your username" value="admin123">
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
            <div class="modal-header border-secondary">
                <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editProfileForm">
                    <!-- Profile Picture Section -->
                    <div class="mb-4 text-center">
                        <img src="https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&auto=format&fit=crop&w=120&q=80"
                             alt="Profile" class="profile-avatar">
                    </div>
                    <div class="row mb-3">
                        <div class="col-12">
                            <div class="mb-3">
                                <label class="form-label">Change Photo</label>
                                <input type="file" class="form-control bg-dark border-secondary text-white" required>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" value="John Doe">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" value="john.doe@example.com">
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="location" class="form-label">Location</label>
                                <input type="text" class="form-control" id="location" value="San Francisco, CA">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" value="+1 (234) 567-8900">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveProfileChanges()">Save Changes</button>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>
</body>
</html>
