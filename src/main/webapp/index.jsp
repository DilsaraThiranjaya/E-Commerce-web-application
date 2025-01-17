<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="includes/head.jsp" %>
    <link rel="stylesheet" href="assets/css/header.css">
    <link rel="stylesheet" href="assets/css/footer.css">
    <link rel="stylesheet" href="assets/css/index.css">
</head>
<body>
<%@include file="includes/header.jsp" %>

<div class="slider-container">
    <div class="slider">
        <div class="slide active">
            <div class="slide-content">
                <h1>MEET ARACHNID</h1>
                <p>A Bold Open Air Marvel</p>
                <button class="learn-more">Learn More</button>
            </div>
            <div class="coming-soon">Coming Soon</div>
        </div>
        <div class="slide">
            <div class="slide-content">
                <h1>PHANTOM PRO</h1>
                <p>Ultimate Gaming Experience</p>
                <button class="learn-more">Learn More</button>
            </div>
            <div class="coming-soon">Coming Soon</div>
        </div>
        <div class="slide">
            <div class="slide-content">
                <h1>ECLIPSE X</h1>
                <p>The Future of Computing</p>
                <button class="learn-more">Learn More</button>
            </div>
            <div class="coming-soon">Coming Soon</div>
        </div>
    </div>

    <button class="slider-nav prev">
        <i class="fa-solid fa-chevron-left text-light"></i>
    </button>
    <button class="slider-nav next">
        <i class="fa-solid fa-chevron-right text-light"></i>
    </button>

    <div class="slider-dots"></div>
</div>

<div class="featured-section">
    <div class="featured-review">
        <div class="review-content">
            <span class="subtitle">FEATURED REVIEW</span>
            <h2>CHRONOS</h2>
            <h3 class="award-title">CHRONOS Gaming Desktop<br>Awarded Editor's Choice by PCMag</h3>
            <p class="quote">"Origin's compact Chronos gaming desktop delivers impressive style and performance..." - PCMAG</p>
            <button class="shop-now">SHOP NOW</button>
        </div>
        <div class="review-image">
            <img src="https://images.unsplash.com/photo-1587202372634-32705e3bf49c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" alt="Chronos Desktop">
            <div class="award-badge">
                <span>PC MAG</span>
                <span>EDITORS'</span>
                <span>CHOICE</span>
            </div>
        </div>
    </div>

    <div class="testimonials">
        <h2>TESTIMONIALS</h2>
        <div class="testimonial-slider">
            <div class="testimonial active">
                <h3 class="highlight">"Great Experience!!!"</h3>
                <p>"Nick was my sales Rep and from the minute I ordered the computer to the time it went out in shipping I got updated on every process, step-by-step. Polite, knowledgeable, and of course the best..."</p>
            </div>
            <div class="testimonial">
                <h3 class="highlight">"Exceptional Quality!"</h3>
                <p>"The build quality exceeded my expectations. Every component was carefully selected and installed with precision. The performance is outstanding!"</p>
            </div>
            <div class="testimonial">
                <h3 class="highlight">"Outstanding Service!"</h3>
                <p>"From customization to delivery, the entire process was smooth and professional. The support team was incredibly helpful throughout."</p>
            </div>
        </div>
        <div class="testimonial-dots"></div>
    </div>
</div>

<%@include file="includes/footer.jsp" %>

<%@include file="includes/script.jsp" %>
<script src="assets/js/index.js"></script>

</body>
</html>