<%@ page import="dto.ProductDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
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
      <div class="stat-title">Total Products</div>
      <div class="stat-value">${totalProducts}</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">In Stock Products</div>
      <div class="stat-value">${inStock}</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">Out of Stock Products</div>
      <div class="stat-value">${outOfStock}</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">Total Categories</div>
      <div class="stat-value">${totalCategories}</div>
    </div>
  </div>

  <div class="toolbar">
    <div class="search-bar">
      <select class="search-dropdown" id="searchType">
        <option value="name">Search by Name</option>
        <option value="category">Search by Category</option>
      </select>
      <input type="text" id="searchInput" class="search-input" placeholder="Type to search...">
      <button class="search-btn" id="searchBtn">Search</button>
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
        <tbody id="productTableBody">
        <%
          List<ProductDTO> productList = (List<ProductDTO>) request.getAttribute("productList");
          if (productList != null && !productList.isEmpty()) {
            for (ProductDTO product : productList) {
              String base64Image = product.getImage() != null
                      ? Base64.getEncoder().encodeToString(product.getImage())
                      : null;
        %>
        <tr>
          <td class="px-4">
            <% if (base64Image != null) { %>
            <img src="data:image/png;base64,<%= base64Image %>"
                 class="rounded" style="width: 50px; height: 50px; object-fit: cover;" alt="Product">
            <% } else { %>
            <span>No Image</span>
            <% } %>
          </td>
          <td><%= product.getName() %></td>
          <td><%= product.getCategoryName() %></td>
          <td>Rs. <%= product.getUnitPrice() %></td>
          <td><%= product.getQtyOnHand() %></td>
          <td class="text-end px-4">
            <button class="btn btn-sm btn-outline-primary me-2"
                    onclick="editProduct(<%= product.getItemCode() %>,
                            '<%= product.getName().replace("'", "\\'") %>',
                            '<%= product.getDescription().replace("'", "\\'") %>',
                      <%= product.getUnitPrice() %>,
                      <%= product.getQtyOnHand() %>,
                      <%= product.getCategoryId() %>)">
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn btn-sm btn-outline-danger" onclick="deleteProduct(<%= product.getItemCode() %>)">
              <i class="fas fa-trash"></i>
            </button>
          </td>
        </tr>
        <%
          }
        } else {
        %>
        <tr>
          <td colspan="6" class="text-center">No products available.</td>
        </tr>
        <%
          }
        %>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Add Product Modal -->
  <div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content bg-dark-secondary">
        <form action="${pageContext.request.contextPath}/product" method="post" enctype="multipart/form-data">
          <input type="hidden" name="action" value="add-product">
          <div class="modal-header border-secondary">
            <h5 class="modal-title text-white">Add New Product</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="mb-3 text-center">
                <!-- Initial profile image -->
                <img id="profileImagePreview" src="${pageContext.request.contextPath}/assets/images/Profile-image.jpg"
                     alt="Profile" class="profile-avatar">
              </div>
              <div class="col-md-6">
                <label class="form-label">Product Name</label>
                <input type="text" name="name" class="form-control bg-dark border-secondary text-white" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Category</label>
                <select name="categoryId" class="form-select bg-dark border-secondary text-white" id="addCategorySelect" required>
                  <!-- Categories will be loaded dynamically -->
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">Price</label>
                <input type="number" name="unitPrice" step="0.01" class="form-control bg-dark border-secondary text-white" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Stock</label>
                <input type="number" name="qtyOnHand" class="form-control bg-dark border-secondary text-white" required>
              </div>
              <div class="col-12">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control bg-dark border-secondary text-white" rows="4" required></textarea>
              </div>
              <div class="col-12">
                <label class="form-label">Product Image</label>
                <input type="file" id="addImage" name="image" class="form-control bg-dark border-secondary text-white" required>
                <div id="image-alert" class="alert d-none"></div>
              </div>
            </div>
          </div>
          <div class="modal-footer border-secondary">
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-primary">Add Product</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Edit Product Modal -->
  <div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content bg-dark-secondary">
        <form id="editProductForm">
          <input type="hidden" id="editItemCode" name="itemCode">
          <div class="modal-header border-secondary">
            <h5 class="modal-title text-white">Edit Product</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Product Name</label>
                <input type="text" id="editName" name="name" class="form-control bg-dark border-secondary text-white" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Category</label>
                <select id="editCategoryId" name="categoryId" class="form-select bg-dark border-secondary text-white" required>
                  <!-- Categories will be loaded dynamically -->
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">Price</label>
                <input type="number" id="editUnitPrice" name="unitPrice" step="0.01" class="form-control bg-dark border-secondary text-white" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Stock</label>
                <input type="number" id="editQtyOnHand" name="qtyOnHand" class="form-control bg-dark border-secondary text-white" required>
              </div>
              <div class="col-12">
                <label class="form-label">Description</label>
                <textarea id="editDescription" name="description" class="form-control bg-dark border-secondary text-white" rows="4" required></textarea>
              </div>
              <div class="col-12">
                <label class="form-label">Product Image</label>
                <input type="file" id="editImage" name="image" class="form-control bg-dark border-secondary text-white">
                <small class="text-muted">Leave empty to keep current image</small>
              </div>
            </div>
          </div>
          <div class="modal-footer border-secondary">
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-primary">Save Changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Delete Confirmation Modal -->
  <div class="modal fade" id="deleteConfirmationModal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content bg-dark-secondary">
        <div class="modal-header border-secondary">
          <h5 class="modal-title text-white">Confirm Deletion</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p class="text-white">Are you sure you want to delete this product?</p>
        </div>
        <div class="modal-footer border-secondary">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
        </div>
      </div>
    </div>
  </div>
</div>

<%@include file="/includes/footer.jsp" %>
<%@include file="/includes/script.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/products.js"></script>
<script>
  // Load categories for dropdowns
  function loadCategories() {
    $.ajax({
      url: '${pageContext.request.contextPath}/product',
      type: 'GET',
      data: { action: 'categories' },
      success: function(categories) {
        const addSelect = $('#addCategorySelect');
        const editSelect = $('#editCategoryId');

        addSelect.empty();
        editSelect.empty();

        categories.forEach(category => {
          const option = `<option value="\${category.id}">\${category.name}</option>`;
          addSelect.append(option);
          editSelect.append(option);
        });
      },
      error: function() {
        alert('Error loading categories');
      }
    });
  }

  // Load categories when page loads
  $(document).ready(function() {
    loadCategories();
  });

  // Search functionality
  $('#searchBtn').click(function() {
    const searchType = $('#searchType').val();
    const searchTerm = $('#searchInput').val();

    $.ajax({
      url: '${pageContext.request.contextPath}/product',
      type: 'GET',
      data: {
        action: 'search',
        searchType: searchType,
        searchTerm: searchTerm
      },
      success: function(products) {
        $('#productTableBody').empty();

        if (products && products.length > 0) {
          products.forEach(product => {
            const row = `
                            <tr>
                                <td class="px-4">
                                    <img src="data:image/png;base64,\${product.image}"
                                         class="rounded" style="width: 50px; height: 50px; object-fit: cover;" alt="Product">
                                </td>
                                <td>\${product.name}</td>
                                <td>\${product.categoryName}</td>
                                <td>Rs. \${product.unitPrice}</td>
                                <td>\${product.qtyOnHand}</td>
                                <td class="text-end px-4">
                                    <button class="btn btn-sm btn-outline-primary me-2"
                                            onclick="editProduct(\${product.itemCode}, '\${product.name}',
                                                    '\${product.description}', \${product.unitPrice},
                                                    \${product.qtyOnHand}, \${product.categoryId})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" onclick="deleteProduct(\${product.itemCode})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        `;
            $('#productTableBody').append(row);
          });
        } else {
          $('#productTableBody').append('<tr><td colspan="6" class="text-center">No products found.</td></tr>');
        }
      },
      error: function() {
        alert('Error searching products');
      }
    });
  });

  // Edit product
  function editProduct(itemCode, name, description, unitPrice, qtyOnHand, categoryId) {
    // Show the modal
    $('#editProductModal').modal('show');

    // Populate the modal fields with the product data
    $('#editItemCode').val(itemCode);
    $('#editName').val(name);
    $('#editDescription').val(description);
    $('#editUnitPrice').val(unitPrice);
    $('#editQtyOnHand').val(qtyOnHand);
    $('#editCategoryId').val(categoryId);
    $('#editProductModal').data('itemCode', itemCode); // Store the item code in the modal
  }

  // Handle edit form submission
  $('#editProductForm').submit(function(e) {
    e.preventDefault();

    const formData = new FormData(this);
    formData.append('action', 'edit-product');

    $.ajax({
      url: '${pageContext.request.contextPath}/product',
      type: 'PUT',
      data: formData,
      processData: false,
      contentType: false,
      success: function(response) {
        if (response.status === 'success') {
          $('#editProductModal').modal('hide');
          location.reload();
        } else {
          alert('Error updating product');
        }
      },
      error: function() {
        alert('Error updating product');
      }
    });
  });

  // Delete product
  function deleteProduct(itemCode) {
    $('#deleteConfirmationModal').modal('show');

    $('#confirmDeleteBtn').off('click').on('click', function() {
      $.ajax({
        url: '${pageContext.request.contextPath}/product',
        type: 'POST',
        data: {
          action: 'delete-product',
          itemCode: itemCode
        },
        success: function() {
          $('#deleteConfirmationModal').modal('hide');
          location.reload();
        },
        error: function() {
          alert('Error deleting product');
        }
      });
    });
  }
</script>

</body>
</html>