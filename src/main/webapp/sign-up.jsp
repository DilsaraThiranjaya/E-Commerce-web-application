<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
<%@include file="includes/header.jsp" %>

<div class="min-vh-100 d-flex align-items-center justify-content-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                <div class="card bg-dark-secondary">
                    <div class="card-body p-4 p-md-5">
                        <h1 class="text-white text-center mb-4">Sign Up</h1>

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

                        <form action="sign-up" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <!-- Profile Picture Section -->
                                <div class="mb-4 text-center">
                                    <!-- Initial profile image -->
                                    <img id="profileImagePreview" src="${pageContext.request.contextPath}/assets/images/Profile-image.jpg"
                                         alt="Profile" class="profile-avatar">
                                </div>
                                <!-- Photo -->
                                <div class="col-12 mb-4">
                                    <label class="form-label text-white">Profile Image</label>
                                    <input type="file" name="image" id="addProfileImage" class="form-control bg-dark border-secondary text-white" required>
                                    <div id="image-alert" class="alert d-none"></div>
                                </div>
                                <!-- Full Name -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Full Name</label>
                                    <input type="text" name="full-name" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your full name" required>
                                </div>
                                <!-- Username -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Username</label>
                                    <input type="text" name="username" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your username" required>
                                </div>
                                <!-- Email -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Email Address</label>
                                    <input type="email" name="email" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your email" required>
                                </div>
                                <!-- Phone Number -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Phone Number</label>
                                    <input type="tel" name="phone" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your phone number" required>
                                </div>
                                <!-- Address -->
                                <div class="col-12 mb-4">
                                    <label class="form-label text-white">Address</label>
                                    <textarea class="form-control bg-dark border-secondary text-white" name="address"
                                              placeholder="Enter your address" rows="3" required></textarea>
                                </div>
                                <!-- Password -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Password</label>
                                    <div class="input-group">
                                    <input type="password" class="form-control bg-dark border-secondary text-white" name="password" id="password"
                                           placeholder="Enter your password" required>
                                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="#password">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    </div>
                                </div>
                                <!-- Confirm Password -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Confirm Password</label>
                                    <div class="input-group">
                                    <input type="password" class="form-control bg-dark border-secondary text-white" name="confirm-password" id="confirmPassword"
                                           placeholder="Confirm your password" required>
                                    <button type="button" class="btn btn-outline-secondary toggle-password" data-target="#confirmPassword">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mb-4">Sign Up</button>
                            <p class="text-center text-white mb-0">
                                Already have an account?
                                <a href="${pageContext.request.contextPath}/log-in.jsp" class="text-primary text-decoration-none">Login</a>
                            </p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="includes/footer.jsp" %>

<%@include file="includes/script.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/sign-up.js"></script>

</body>
</html>
