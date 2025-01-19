<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
</head>
<body>
<%@include file="/includes/admin-header.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="text-white">Product Management</h1>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="fas fa-plus me-2"></i>Add Product
        </button>
    </div>

    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Products</div>
            <div class="stat-value">248</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">In Stock Products</div>
            <div class="stat-value">186</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Out of Stock Products</div>
            <div class="stat-value">24</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Total Categories</div>
            <div class="stat-value">12</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-bar">
            <select class="search-dropdown">
                <option value="name">Search by Name</option>
                <option value="category">Search by Category</option>
            </select>
            <input type="text" class="search-input" placeholder="Type to search...">
            <button class="search-btn">Search</button>
        </div>
    </div>

    <!-- Products Table -->
    <div class="card bg-dark-secondary">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0">
                <thead>
                <tr>
                    <th class="px-4">Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th class="text-end px-4">Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="px-4">
                        <img src="https://images.unsplash.com/photo-1587202372634-32705e3bf49c?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80"
                             class="rounded" style="width: 50px; height: 50px; object-fit: cover;" alt="Product">
                    </td>
                    <td>Gaming PC Pro</td>
                    <td>Desktop</td>
                    <td>$999.99</td>
                    <td>50</td>
                    <td class="text-end px-4">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="editProduct(1)">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Add New Product</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addProductForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Product Name</label>
                                <input type="text" class="form-control bg-dark border-secondary text-white">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Category</label>
                                <select class="form-select bg-dark border-secondary text-white">
                                    <option>Desktop</option>
                                    <option>Laptop</option>
                                    <option>Accessories</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Price</label>
                                <input type="number" class="form-control bg-dark border-secondary text-white">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Stock</label>
                                <input type="number" class="form-control bg-dark border-secondary text-white">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Description</label>
                                <textarea class="form-control bg-dark border-secondary text-white" rows="4"></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Product Image</label>
                                <input type="file" class="form-control bg-dark border-secondary text-white" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Add Product</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Product Modal -->
    <div class="modal fade" id="editProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Edit Product</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editProductForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Product Name</label>
                                <input type="text" class="form-control bg-dark border-secondary text-white" value="Gaming PC Pro">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Category</label>
                                <select class="form-select bg-dark border-secondary text-white">
                                    <option selected>Desktop</option>
                                    <option>Laptop</option>
                                    <option>Accessories</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Price</label>
                                <input type="number" class="form-control bg-dark border-secondary text-white" value="999.99">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Stock</label>
                                <input type="number" class="form-control bg-dark border-secondary text-white" value="50">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Description</label>
                                <textarea class="form-control bg-dark border-secondary text-white" rows="4">High-performance gaming desktop</textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Product Image</label>
                                <input type="file" class="form-control" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>

<script>
    function editProduct(id) {
        // In a real application, you would fetch the product data here
        $('#editProductModal').modal('show');
    }

    // Initialize tooltips
    $(function () {
        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>

</body>
</html>
