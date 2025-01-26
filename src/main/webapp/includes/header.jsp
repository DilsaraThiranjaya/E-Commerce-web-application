<!-- Top Bar -->
<div class="top-bar bg-primary text-white py-2">
    <div class="container-fluid">
        <div class="row align-items-center">
            <div class="col-md-6 d-flex align-items-center">
                <div class="top-bar-item me-4">
                    <i class="fas fa-phone-alt me-2"></i>
                    +94 766 677 409
                </div>
                <div class="top-bar-item">
                    <i class="fas fa-envelope me-2"></i>
                    <a href="mailto:contact@technocomputers.lk"
                       class="text-white text-decoration-none">contact@technocomputers.lk</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="d-flex justify-content-end align-items-center">
                    <div class="social-icons">
                        <a href="#" class="text-white me-2"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-white me-2"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Header -->
<header class="main-header shadow-sm border border-3 border-primary">
    <div class="container-fluid">
        <nav class="navbar navbar-expand-lg navbar-light p-3">
            <!-- Logo -->
            <a class="navbar-brand d-flex align-items-center" href="#">
                <img src="assets/images/Techno-logo.png" class="header-logo me-3" alt="logo">
                <span class="fw-bold text-light">Techno Computers</span>
            </a>

            <!-- Mobile Toggle Button -->
            <button class="navbar-toggler text-light" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <i class="fa-solid fa-bars text-light"></i>
            </button>

            <!-- Navigation Content -->
            <div class="collapse navbar-collapse d-lg-flex justify-content-end" id="navbarContent">
                <ul class="navbar-nav mb-2 mb-lg-0 mt-lg-0 mt-3">
                    <li class="nav-item me-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home me-1"></i> Home</a>
                    </li>
                    <li class="nav-item me-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/log-in.jsp"><i class="fas fa-sign-in-alt me-1"></i> Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/sign-up.jsp"><i class="fas fa-user-plus me-1"></i> Sign Up</a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</header>