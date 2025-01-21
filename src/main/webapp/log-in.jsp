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
            <div class="col-md-6 col-lg-5">
                <div class="card bg-dark-secondary">
                    <div class="card-body p-4 p-md-5">
                        <h1 class="text-white text-center mb-4">Login</h1>

                        <!-- Display success or error messages -->
                        <%
                            String error = request.getParameter("error");
                        %>

                        <% if (error != null) { %>
                        <div class="alert alert-danger">
                            <%=error%>
                        </div>
                        <% } %>

                        <form action="log-in-action" method="post">
                            <div class="mb-4">
                                <label class="form-label text-white">Email</label>
                                <input type="email" name="email" class="form-control bg-dark border-secondary text-white"
                                       placeholder="Enter your email">
                            </div>
                            <div class="mb-4">
                                <label class="form-label text-white">Password</label>
                                <input type="password" name="password" class="form-control bg-dark border-secondary text-white"
                                       placeholder="Enter your password">
                            </div>
                            <div class="mb-4 d-flex justify-content-between align-items-center">
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="remember">
                                    <label class="form-check-label text-white" for="remember">
                                        Remember me
                                    </label>
                                </div>
                                <a href="${pageContext.request.contextPath}/forgot-password.jsp" class="text-primary text-decoration-none">Forgot password?</a>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mb-4">Login</button>
                            <p class="text-center text-white mb-0">
                                Don't have an account?
                                <a href="${pageContext.request.contextPath}/sign-up.jsp" class="text-primary text-decoration-none">Sign up</a>
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