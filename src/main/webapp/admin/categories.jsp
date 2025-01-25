<%@ page import="dto.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
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

    <div class="quick-stats">
        <div class="stat-card">
            <div class="stat-title">Total Categories</div>
            <div class="stat-value">${totalCategories}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Categories</div>
            <div class="stat-value">${activeCategories}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Products Categorized</div>
            <div class="stat-value">${productsCategorized}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Uncategorized Products</div>
            <div class="stat-value">${uncategorizedProducts}</div>
        </div>
    </div>


    <div class="toolbar">
        <div class="search-bar">
            <input type="text" id="searchBar" class="search-input" placeholder="Search categories...">
            <button class="search-btn" id="searchCategoryBtn">Search</button>
        </div>
    </div>

    <!-- Categories Table -->
    <div class="card bg-dark-secondary">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0">
                <thead>
                <tr>
                    <th>Icon</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th class="text-end px-4">Actions</th>
                </tr>
                </thead>
                <tbody id="tableBody">
                <%
                    List<CategoryDTO> categoryList = (List<CategoryDTO>) request.getAttribute("categoryList");
                    if (categoryList != null && !categoryList.isEmpty()) {
                        for (CategoryDTO category : categoryList) {
                            // Convert the icon (byte[]) to a Base64 string
                            String base64Icon = category.getIcon() != null
                                    ? Base64.getEncoder().encodeToString(category.getIcon())
                                    : null;
                %>
                <tr>
                    <td>
                        <% if (base64Icon != null) { %>
                        <img src="data:image/png;base64,<%= base64Icon %>" alt="Category Icon" style="width: 40px; height: 40px; object-fit: cover; border-radius: 5%;">
                        <% } else { %>
                        <span>No Icon</span>
                        <% } %>
                    </td>
                    <td><%= category.getName() %></td>
                    <td><%= category.getDescription() %></td>
                    <td>
                        <% if ("Active".equals(category.getStatus())) { %>
                        <span class="badge bg-success">Active</span>
                        <% } else { %>
                        <span class="badge bg-secondary">Draft</span>
                        <% } %>
                    </td>
                    <td class="text-end px-4">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="editCategory(<%= category.getId() %>,
                                '<%= category.getName().replace("'", "\\'") %>',
                                '<%= category.getDescription().replace("'", "\\'") %>',
                                '<%= category.getStatus().replace("'", "\\'") %>')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(<%= category.getId() %>)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="5" class="text-center">No categories available.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark-secondary">
                <form  action="/E_Commerce_web_application_war_exploded/category" method="post" enctype="multipart/form-data">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">Add New Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                        <input type="hidden" name="action" value="add-category">
                        <div class="mb-3 text-center">
                            <!-- Initial profile image -->
                            <img id="profileImagePreview" src="${pageContext.request.contextPath}/assets/images/Profile-image.jpg"
                                 alt="Profile" class="profile-avatar">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Category Name</label>
                            <input type="text" name="name" class="form-control bg-dark border-secondary text-white" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control bg-dark border-secondary text-white" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select bg-dark border-secondary text-white" name="status">
                                <option value="active">Active</option>
                                <option value="draft">Draft</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Icon</label>
                            <input type="file" id="addIcon" name="icon" class="form-control bg-dark border-secondary text-white" required>
                            <div id="image-alert" class="alert d-none"></div>
                        </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Category</button>
                </div>
                </form>
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
                            <input type="text" id="editCategoryName" class="form-control bg-dark border-secondary text-white">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea id="editCategoryDescription" class="form-control bg-dark border-secondary text-white" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select id="editCategoryStatus" class="form-select bg-dark border-secondary text-white">
                                <option value="Active" selected>Active</option>
                                <option value="Draft">Draft</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Icon</label>
                            <input type="file" id="editCategoryIcon" class="form-control bg-dark border-secondary text-white">
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveChangesBtn">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-labelledby="deleteConfirmationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content bg-dark-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title text-white" id="deleteConfirmationModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="text-white">Are you sure you want to delete this category?</p>
            </div>
            <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>

<%@include file="/includes/script.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/category.js"></script>
<script>
    function editCategory(id, name, description, status) {
        // Show the modal
        $('#editCategoryModal').modal('show');

        // Populate the modal fields with the category data
        $('#editCategoryName').val(name); // Set category name
        $('#editCategoryDescription').val(description); // Set category description
        $('#editCategoryStatus').val(status); // Set category status
        $('#editCategoryModal').data('categoryId', id); // Store the category ID in the modal for later use
    }

    function deleteCategory(id) {
        $('#deleteConfirmationModal').modal('show');

        $('#confirmDeleteBtn').off('click').on('click', function() {
            if (id) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '/E_Commerce_web_application_war_exploded/category';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete-category';
                form.appendChild(actionInput);

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                form.appendChild(idInput);

                document.body.appendChild(form);
                form.submit();
            }
        });
    }


    $('#saveChangesBtn').click(function() {
        let categoryId = $('#editCategoryModal').data('categoryId'); // Get the category ID stored in the modal
        let name = $('#editCategoryName').val(); // Get the category name
        let description = $('#editCategoryDescription').val(); // Get the category description
        let status = $('#editCategoryStatus').val(); // Get the category status
        let icon = $('#editCategoryIcon')[0].files[0]; // Get the uploaded icon file

        let formData = new FormData();
        formData.append('categoryId', categoryId);
        formData.append('name', name);
        formData.append('description', description);
        formData.append('status', status);
        if (icon) {
            formData.append('icon', icon);
        }

        $.ajax({
            url: '/E_Commerce_web_application_war_exploded/category',
            type: 'PUT',
            data: formData,
            processData: false, // Don't process the data
            contentType: false, // Don't set content type
            success: function(response) {
                $('#editCategoryModal').modal('hide');
                location.reload();
            },
            error: function(response) {
                $('#editCategoryModal').modal('hide');
                location.reload();
            }
        });
    });

    $('#searchCategoryBtn').click(function() {
        let name = $('#searchBar').val();
        let action = "search";

        $.ajax({
            url: '/E_Commerce_web_application_war_exploded/category',  // Endpoint for searching categories
            type: 'GET',
            data: { name: name, action: action},
            success: function(response) {
                console.log(response); // Log the response to check its structure
                $('#tableBody').empty();

                if (response && response.length > 0) {
                    for (const category of response) {
                        const statusBadge = category.status === 'Active'
                            ? '<span class="badge bg-success">Active</span>'
                            : '<span class="badge bg-secondary">Draft</span>';

                        const iconHtml = category.icon
                            ? '<img src="data:image/png;base64,' + category.icon + '" ' +
                            'alt="Category Icon" ' +
                            'style="width: 40px; height: 40px; object-fit: cover; border-radius: 5%;">'
                            : '<span>No Icon</span>';

                        // Escape special characters in name and desc
                        const categoryName = $('<div>').text(category.name).html();
                        const categoryDesc = $('<div>').text(category.desc).html();

                        // console.log(statusBadge + iconHtml+ category.status+ categoryName + categoryDesc);

                        $('#tableBody').append(
                            '<tr>' +
                            '<td>' + iconHtml + '</td>' +
                            '<td>' + categoryName + '</td>' +
                            '<td>' + categoryDesc + '</td>' +
                            '<td>' + statusBadge + '</td>' +
                            '<td class="text-end px-4">' +
                            '<button class="btn btn-sm btn-outline-primary me-2" ' +
                            'onclick="editCategory(' + category.id + ', \'' + categoryName + '\', \'' + categoryDesc + '\', \'' + category.status + '\')">' +
                            '<i class="fas fa-edit"></i>' +
                            '</button>' +
                            '<button class="btn btn-sm btn-outline-danger" ' +
                            'onclick="deleteCategory(' + category.id + ')">' +
                            '<i class="fas fa-trash"></i>' +
                            '</button>' +
                            '</td>' +
                            '</tr>'
                        );
                    }
                } else {
                    $('#tableBody').append('<tr><td colspan="5" class="text-center">No categories available.</td></tr>');
                }
            },
            error: function() {
                alert('Error fetching categories.');
            }
        });
    });
</script>
</body>
</html>
