<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/includes/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/categories.css">
</head>
<body>
<%@include file="/includes/admin-header.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="text-white">Category Management</h1>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
            <i class="fas fa-plus me-2"></i>Add Category
        </button>
    </div>

    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Categories</div>
            <div class="stat-value">12</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Categories</div>
            <div class="stat-value">10</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Products Categorized</div>
            <div class="stat-value">248</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Uncategorized Products</div>
            <div class="stat-value">3</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-bar">
            <input type="text" class="search-input" placeholder="Search categories...">
            <button class="search-btn">Search</button>
        </div>
    </div>

    <!-- Categories Table -->
    <div class="card bg-dark-secondary">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Products Count</th>
                    <th>Status</th>
                    <th class="text-end px-4">Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>Desktop Computers</td>
                    <td>High-performance desktop PCs</td>
                    <td>45</td>
                    <td><span class="badge bg-success">Active</span></td>
                    <td class="text-end px-4">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="editCategory(1)">
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

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Add New Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addCategoryForm">
                        <div class="mb-3">
                            <label class="form-label">Category Name</label>
                            <input type="text" class="form-control bg-dark border-secondary text-white">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control bg-dark border-secondary text-white" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select bg-dark border-secondary text-white">
                                <option value="active">Active</option>
                                <option value="draft">Draft</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Icon (Optional)</label>
                            <input type="file" class="form-control bg-dark border-secondary text-white">
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Add Category</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Category Modal -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Edit Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editCategoryForm">
                        <div class="mb-3">
                            <label class="form-label">Category Name</label>
                            <input type="text" class="form-control bg-dark border-secondary text-white" value="Desktop Computers">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control bg-dark border-secondary text-white" rows="3">High-performance desktop PCs</textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select bg-dark border-secondary text-white">
                                <option value="active" selected>Active</option>
                                <option value="draft">Draft</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Icon</label>
                            <input type="file" class="form-control bg-dark border-secondary text-white">
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
    function editCategory(id) {
        $('#editCategoryModal').modal('show');
    }

    // Initialize tooltips
    $(function () {
        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>
</body>
</html>
