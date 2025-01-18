<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/store.css">
</head>
<body>
<%@include file="/includes/customer-header.jsp" %>

<div class="container py-4">
    <!-- Categories -->
    <div class="row g-3 mb-4 d-flex justify-content-center">
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3">
                <i class="fas fa-laptop category-icon mb-2"></i>
                <div>Laptops</div>
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3">
                <i class="fas fa-desktop category-icon mb-2"></i>
                <div>Desktop</div>
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3">
                <i class="fas fa-microchip category-icon mb-2"></i>
                <div>Processors</div>
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3">
                <i class="fas fa-memory category-icon mb-2"></i>
                <div>Memory</div>
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3">
                <i class="fas fa-hdd category-icon mb-2"></i>
                <div>Storage</div>
            </div>
        </div>
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3">
                <i class="fas fa-fan category-icon mb-2"></i>
                <div>Cooling</div>
            </div>
        </div>
    </div>

    <hr>

    <div class="toolbar">
        <div class="search-bar">
            <input type="text" class="search-input" placeholder="Search by Name...">
            <button class="search-btn">Search</button>
        </div>
    </div>

    <hr>

    <!-- Filters -->
    <div class="row">
        <div class="col-md-3">
            <div class="filter-section">
                <h5 class="mb-3">Filter by Price</h5>
                <input type="range" class="form-range" id="priceRange" min="0" max="500000">
                <div class="price-range mt-2">
                    Rs. 0 - Rs. 500,000
                </div>

                <h5 class="mb-3 mt-4">Product Availability</h5>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="inStock">
                    <label class="form-check-label" for="inStock">
                        In Stock
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="outOfStock">
                    <label class="form-check-label" for="outOfStock">
                        Out of Stock
                    </label>
                </div>
                <button class="btn btn-cart btn-primary mt-5">
                    <i class="fa-solid fa-filter me-2"></i>Filter
                </button>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="col-md-9">
            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="product-card card">
                        <span class="stock-badge">IN STOCK</span>
                        <img src="" class="product-img" alt="Product">
                        <div class="card-body">
                            <h5 class="product-title">Intel Core i5-14400 Processor</h5>
                            <div class="product-category">Processors</div>
                            <div class="mt-2">
                                <div class="product-price">Rs. 55,000.00</div>
                            </div>
                            <button class="btn btn-cart btn-primary">
                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="product-card card">
                        <span class="stock-badge">IN STOCK</span>
                        <img src="" class="product-img" alt="Product">
                        <div class="card-body">
                            <h5 class="product-title">Lenovo V15 G4 IRU i3 13th Gen</h5>
                            <div class="product-category">Laptops</div>
                            <div class="mt-2">
                                <div class="product-price">Rs. 134,900.00</div>
                            </div>
                            <button class="btn btn-cart btn-primary">
                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="product-card card">
                        <span class="stock-badge">IN STOCK</span>
                        <img src="" class="product-img" alt="Product">
                        <div class="card-body">
                            <h5 class="product-title">MSI KATANA 15 B13VEK i7</h5>
                            <div class="product-category">Laptops</div>
                            <div class="mt-2">
                                <div class="product-price">Rs. 336,900.00</div>
                            </div>
                            <button class="btn btn-cart btn-primary">
                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const priceRange = document.getElementById('priceRange');
        const priceDisplay = document.querySelector('.price-range');

        priceRange.addEventListener('input', function() {
            const value = this.value;
            priceDisplay.textContent = 'Rs. 0 - Rs. ' + parseInt(value).toLocaleString();
        });
    });
</script>

</body>
</html>
