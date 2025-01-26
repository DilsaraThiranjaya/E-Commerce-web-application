<%@ page import="lk.ijse.ecommercewebapplication.dto.ProductDTO" %>
<%@ page import="lk.ijse.ecommercewebapplication.dto.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
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
        <%
            List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
            if (categories != null && !categories.isEmpty()) {
                for (CategoryDTO category : categories) {
                    String base64Icon = Base64.getEncoder().encodeToString(category.getIcon());
        %>
        <div class="col-6 col-md-3 col-lg-2">
            <div class="category-card card text-center p-3" onclick="filterByCategory(<%= category.getId() %>)">
                <img src="data:image/png;base64,<%= base64Icon %>" alt="<%= category.getName() %>"
                     class="category-icon mb-2">
                <div><%= category.getName() %>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <hr>

    <div class="toolbar">
        <div class="search-bar">
            <input type="text" id="searchInput" class="search-input" placeholder="Search by Name...">
            <button class="search-btn" onclick="searchProducts()">Search</button>
        </div>
    </div>

    <hr>

    <!-- Filters -->
    <div class="row">
        <div class="col-md-3">
            <div class="filter-section">
                <h5 class="mb-3">Filter by Price</h5>
                <input type="range" class="form-range" id="priceRange" min="0" max="500000" value="500000">
                <div class="price-range mt-2">
                    Rs. 0 - Rs. 500,000
                </div>

                <h5 class="mb-3 mt-4">Product Availability</h5>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="inStock" checked>
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
                <button class="btn btn-cart btn-primary mt-5" onclick="applyFilters()">
                    <i class="fa-solid fa-filter me-2"></i>Filter
                </button>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="col-md-9">
            <div class="row g-4" id="productsContainer">
                <%
                    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                    if (products != null && !products.isEmpty()) {
                        for (ProductDTO product : products) {
                            String base64Image = Base64.getEncoder().encodeToString(product.getImage());
                %>
                <div class="col-md-6 col-lg-4">
                    <div class="product-card card">
                        <span class="<%= product.getQtyOnHand() > 0 ? "stock-badge" : "no-stock-badge" %>">
                        <%= product.getQtyOnHand() > 0 ? "IN STOCK" : "OUT OF STOCK" %></span>
                        <img src="data:image/png;base64,<%= base64Image %>" class="product-img"
                             alt="<%= product.getName() %>">
                        <div class="card-body">
                            <h5 class="product-title"><%= product.getName() %>
                            </h5>
                            <div class="product-category"><%= product.getCategoryName() %>
                            </div>
                            <div class="mt-2">
                                <div class="product-price">Rs. <%= String.format("%,.2f", product.getUnitPrice()) %>
                                </div>
                            </div>
                            <button
                                    class="btn btn-secondary btn-view"
                                    data-bs-toggle="modal"
                                    data-bs-target="#productModal"
                                    data-itemCode="<%= product.getItemCode() %>"
                                    data-name="<%= product.getName() %>"
                                    data-category="<%= product.getCategoryName() %>"
                                    data-price="Rs. <%= String.format("%,.2f", product.getUnitPrice()) %>"
                                    data-image="data:image/png;base64,<%= base64Image %>"
                                    data-description="<%= product.getDescription() %>">
                                View Details
                            </button>

                            <button class="btn btn-cart btn-primary" onclick="addToCart(<%= product.getItemCode() %>)">
                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                            </button>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="col-12 text-center">
                    <p>No products available.</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>

<%-- Product Modal --%>
<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productModalLabel">Product Name</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <img id="modalProductImage" src="" alt="Product Image" class="img-fluid rounded">
                    </div>
                    <div class="col-md-6">
                        <h5 id="modalProductCategory" class="text-uppercase text-secondary"></h5>
                        <h4 id="modalProductPrice" class="text-primary my-3"></h4>
                        <p id="modalProductDescription"></p>
                        <button id="modalProductAddToCart" class="btn btn-primary btn-cart" onclick="">
                            <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>

<script>
    let currentProductId = null;

    function updateProductsGrid(products) {
        const container = document.getElementById('productsContainer');
        container.innerHTML = '';

        if (products.length === 0) {
            container.innerHTML = '<div class="col-12 text-center"><p>No products found.</p></div>';
            return;
        }

        products.forEach(product => {
            const productHtml =
                '<div class="col-md-6 col-lg-4">' +
                '<div class="product-card card">' +
                '<span class="' + (product.qtyOnHand > 0 ? 'stock-badge' : 'no-stock-badge') + '">' + (product.qtyOnHand > 0 ? 'IN STOCK' : 'OUT OF STOCK') + '</span>' +
                '<img src="data:image/png;base64,' + product.image + '" class="product-img" alt="' + product.name + '">' +
                '<div class="card-body">' +
                '<h5 class="product-title">' + product.name + '</h5>' +
                '<div class="product-category">' + product.categoryName + '</div>' +
                '<div class="mt-2">' +
                '<div class="product-price">Rs. ' + product.price.toLocaleString('en-US', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                }) + '</div>' +
                '</div>' +
                '<button class="btn btn-secondary btn-view" ' +
                'data-bs-toggle="modal" ' +
                'data-bs-target="#productModal" ' +
                'data-name="' + product.name + '" ' +
                'data-category="' + product.categoryName + '" ' +
                'data-price="Rs. ' + product.price.toLocaleString('en-US', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                }) + '" ' +
                'data-image="data:image/png;base64,' + product.image + '" ' +
                'data-description="' + product.description + '">' +
                'View Details' +
                '</button>' +
                '<button class="btn btn-cart btn-primary" onclick="addToCart(' + product.itemCode + ')">' +
                '<i class="fas fa-shopping-cart me-2"></i>Add to Cart' +
                '</button>' +
                '</div>' +
                '</div>' +
                '</div>';

            container.innerHTML += productHtml;
        });

        // Reinitialize modal event listeners
        initializeModalListeners();
    }

    function searchProducts() {
        const searchTerm = document.getElementById('searchInput').value;

        fetch('/E_Commerce_web_application_war_exploded/store?action=search&term=' + searchTerm)
            .then(response => response.json())
            .then(products => {
                updateProductsGrid(products);
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to search products');
            });
    }

    function applyFilters() {
        const maxPrice = document.getElementById('priceRange').value;
        const inStock = document.getElementById('inStock').checked;
        const outOfStock = document.getElementById('outOfStock').checked;

        fetch('/E_Commerce_web_application_war_exploded/store?action=filter&maxPrice=' + maxPrice + '&inStock=' + inStock + '&outOfStock=' + outOfStock)
            .then(response => response.json())
            .then(products => {
                updateProductsGrid(products);
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to filter products');
            });
    }

    function filterByCategory(categoryId) {
        fetch('/E_Commerce_web_application_war_exploded/store?action=category&categoryId=' + categoryId)
            .then(response => response.json())
            .then(products => {
                updateProductsGrid(products);
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to filter products by category');
            });
    }

    function addToCart(itemCode) {
        fetch('/E_Commerce_web_application_war_exploded/cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=add&itemCode=' + itemCode + '&quantity=1'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Product added to cart successfully!');
                } else if (data.error) {
                    if (data.error === "User not logged in") {
                        window.location.href = '/E_Commerce_web_application_war_exploded/log-in.jsp';
                    } else {
                        alert(data.error);
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to add product to cart');
            });
    }

    function initializeModalListeners() {
        const modal = document.getElementById('productModal');
        const modalTitle = modal.querySelector('#productModalLabel');
        const modalImage = modal.querySelector('#modalProductImage');
        const modalCategory = modal.querySelector('#modalProductCategory');
        const modalPrice = modal.querySelector('#modalProductPrice');
        const modalDescription = modal.querySelector('#modalProductDescription');
        const modalAddToCart = modal.querySelector('#modalProductAddToCart');

        document.querySelectorAll('.btn-view').forEach(button => {
            button.addEventListener('click', () => {
                const name = button.getAttribute('data-name');
                const category = button.getAttribute('data-category');
                const price = button.getAttribute('data-price');
                const image = button.getAttribute('data-image');
                const description = button.getAttribute('data-description');
                const itemCode = button.getAttribute('data-itemCode');

                modalTitle.textContent = name;
                modalCategory.textContent = category;
                modalPrice.textContent = price;
                modalImage.src = image;
                modalDescription.textContent = description;
                modalAddToCart.onclick = () => addToCart(itemCode);
            });
        });
    }

    // Initialize price range display
    document.addEventListener('DOMContentLoaded', function () {
        const priceRange = document.getElementById('priceRange');
        const priceDisplay = document.querySelector('.price-range');

        priceRange.addEventListener('input', function () {
            const value = this.value;
            priceDisplay.textContent = 'Rs. 0 - Rs. ' + parseInt(value).toLocaleString();
        });

        // Initialize modal listeners
        initializeModalListeners();
    });
</script>

</body>
</html>