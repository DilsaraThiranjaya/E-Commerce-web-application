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
            <h1 class="text-white text-center mb-4">Forgot Password</h1>
            <form>
              <div class="mb-4">
                <label class="form-label text-white">Email Address</label>
                <input type="email" class="form-control bg-dark border-secondary text-white"
                       placeholder="Enter your email">
              </div>
              <button type="submit" class="btn btn-primary w-100 mb-4">Reset Password</button>
              <p class="text-center text-white mb-0">
                Remember your password?
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