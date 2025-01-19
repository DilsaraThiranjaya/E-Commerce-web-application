<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="includes/head.jsp" %>
    <link rel="stylesheet" href="assets/css/header.css">
    <link rel="stylesheet" href="assets/css/footer.css">
    <link rel="stylesheet" href="assets/css/login.css">
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
                        <form>
                            <div class="row">
                                <!-- Photo -->
                                <div class="col-12 mb-4">
                                    <label class="form-label text-white">Profile Image</label>
                                    <input type="file" class="form-control bg-dark border-secondary text-white">
                                </div>
                                <!-- Full Name -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Full Name</label>
                                    <input type="text" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your full name">
                                </div>
                                <!-- Username -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Username</label>
                                    <input type="text" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your username">
                                </div>
                                <!-- Email -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Email Address</label>
                                    <input type="email" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your email">
                                </div>
                                <!-- Phone Number -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Phone Number</label>
                                    <input type="tel" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your phone number">
                                </div>
                                <!-- Address -->
                                <div class="col-12 mb-4">
                                    <label class="form-label text-white">Address</label>
                                    <textarea class="form-control bg-dark border-secondary text-white"
                                              placeholder="Enter your address" rows="3"></textarea>
                                </div>
                                <!-- Password -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Password</label>
                                    <input type="password" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Enter your password">
                                </div>
                                <!-- Confirm Password -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label text-white">Confirm Password</label>
                                    <input type="password" class="form-control bg-dark border-secondary text-white"
                                           placeholder="Confirm your password">
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

</body>
</html>
