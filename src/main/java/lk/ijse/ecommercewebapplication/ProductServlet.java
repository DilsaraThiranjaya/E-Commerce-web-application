package lk.ijse.ecommercewebapplication;

import lk.ijse.ecommercewebapplication.dto.ProductDTO;
import jakarta.annotation.Resource;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@WebServlet(name = "productServlet", value = "/product")
@MultipartConfig
public class ProductServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            handleSearch(req, resp);
            return;
        }

        if ("categories".equals(action)) {
            fetchCategories(resp);
            return;
        }

        String successMessage = (String) req.getSession().getAttribute("productMessage");
        String errorMessage = (String) req.getSession().getAttribute("productError");

        StringBuilder redirectUrl = new StringBuilder();

        if (errorMessage != null) {
            redirectUrl.append("admin/products.jsp?error=").append(URLEncoder.encode(errorMessage, "UTF-8"));
            req.getSession().removeAttribute("productError");
        } else if (successMessage != null) {
            redirectUrl.append("admin/products.jsp?message=").append(URLEncoder.encode(successMessage, "UTF-8"));
            req.getSession().removeAttribute("productMessage");
        } else {
            redirectUrl.append("admin/products.jsp");
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT p.*, c.name as category_name FROM products p " +
                    "JOIN categories c ON p.categoryId = c.id";
            PreparedStatement pstm = connection.prepareStatement(sql);
            ResultSet resultSet = pstm.executeQuery();

            List<ProductDTO> productList = new ArrayList<>();

            while (resultSet.next()) {
                ProductDTO productDTO = new ProductDTO();
                productDTO.setItemCode(resultSet.getInt("itemCode"));
                productDTO.setName(resultSet.getString("name"));
                productDTO.setDescription(resultSet.getString("description"));
                productDTO.setUnitPrice(resultSet.getBigDecimal("unitPrice"));
                productDTO.setQtyOnHand(resultSet.getInt("qtyOnHand"));
                productDTO.setImage(resultSet.getBytes("image"));
                productDTO.setCategoryId(resultSet.getInt("categoryId"));
                productDTO.setCategoryName(resultSet.getString("category_name"));

                productList.add(productDTO);
            }

            // Get statistics
            sql = "SELECT " +
                    "(SELECT COUNT(*) FROM products) as total_products, " +
                    "(SELECT COUNT(*) FROM products WHERE qtyOnHand > 0) as in_stock, " +
                    "(SELECT COUNT(*) FROM products WHERE qtyOnHand = 0) as out_of_stock, " +
                    "(SELECT COUNT(*) FROM categories) as total_categories";

            pstm = connection.prepareStatement(sql);
            resultSet = pstm.executeQuery();

            if (resultSet.next()) {
                req.setAttribute("totalProducts", resultSet.getInt("total_products"));
                req.setAttribute("inStock", resultSet.getInt("in_stock"));
                req.setAttribute("outOfStock", resultSet.getInt("out_of_stock"));
                req.setAttribute("totalCategories", resultSet.getInt("total_categories"));
            }

            req.setAttribute("productList", productList);
            req.getRequestDispatcher(String.valueOf(redirectUrl)).forward(req, resp);

        } catch (SQLException e) {
            resp.sendRedirect("admin/products.jsp?error=Unable to load products.");
            throw new RuntimeException(e);
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String searchType = req.getParameter("searchType");
        String searchTerm = req.getParameter("searchTerm");

        try (Connection connection = dataSource.getConnection()) {
            String sql;
            if ("name".equals(searchType)) {
                sql = "SELECT p.*, c.name as category_name FROM products p " +
                        "JOIN categories c ON p.categoryId = c.id " +
                        "WHERE p.name LIKE ?";
            } else {
                sql = "SELECT p.*, c.name as category_name FROM products p " +
                        "JOIN categories c ON p.categoryId = c.id " +
                        "WHERE c.name LIKE ?";
            }

            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, "%" + searchTerm + "%");

            ResultSet resultSet = pstm.executeQuery();
            JsonArrayBuilder productsArray = Json.createArrayBuilder();

            while (resultSet.next()) {
                System.out.println();
                JsonObjectBuilder product = Json.createObjectBuilder()
                        .add("itemCode", resultSet.getInt("itemCode"))
                        .add("name", resultSet.getString("name"))
                        .add("categoryId", resultSet.getString("categoryId"))
                        .add("categoryName", resultSet.getString("category_name"))
                        .add("unitPrice", resultSet.getBigDecimal("unitPrice"))
                        .add("qtyOnHand", resultSet.getInt("qtyOnHand"))
                        .add("description", resultSet.getString("description"))
                        .add("image", Base64.getEncoder().encodeToString(resultSet.getBytes("image")));

                productsArray.add(product);
            }

            JsonArray jsonResponse = productsArray.build();
            resp.setContentType("application/json");
            resp.getWriter().write(jsonResponse.toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Database error occurred");
        }
    }

    private void fetchCategories(HttpServletResponse resp) throws IOException {
        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT id, name FROM categories WHERE status = 'Active'";
            PreparedStatement pstm = connection.prepareStatement(sql);
            ResultSet resultSet = pstm.executeQuery();

            JsonArrayBuilder categoriesArray = Json.createArrayBuilder();

            while (resultSet.next()) {
                JsonObjectBuilder category = Json.createObjectBuilder()
                        .add("id", resultSet.getInt("id"))
                        .add("name", resultSet.getString("name"));

                categoriesArray.add(category);
            }

            JsonArray jsonResponse = categoriesArray.build();
            resp.setContentType("application/json");
            resp.getWriter().write(jsonResponse.toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Database error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        switch (action) {
            case "add-product":
                addProduct(req, resp);
                break;
            case "delete-product":
                deleteProduct(req, resp);
                break;
        }
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        BigDecimal unitPrice = new BigDecimal(req.getParameter("unitPrice"));
        String description = req.getParameter("description");
        int qtyOnHand = Integer.parseInt(req.getParameter("qtyOnHand"));
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));

        Part imagePart = req.getPart("image");
        InputStream imageInputStream = null;

        if (imagePart != null) {
            imageInputStream = imagePart.getInputStream();
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO products (name, unitPrice, description, qtyOnHand, image, categoryId) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, name);
            pstm.setBigDecimal(2, unitPrice);
            pstm.setString(3, description);
            pstm.setInt(4, qtyOnHand);

            if (imageInputStream != null) {
                pstm.setBlob(5, imageInputStream);
            } else {
                pstm.setNull(5, java.sql.Types.BLOB);
            }

            pstm.setInt(6, categoryId);

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("productMessage", "Product successfully added!");
            } else {
                req.getSession().setAttribute("productError", "Failed to add product!");
            }
            resp.sendRedirect("product");

        } catch (SQLException e) {
            req.getSession().setAttribute("productError", "Failed to add product!");
            resp.sendRedirect("product");
            throw new RuntimeException(e);
        }
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int itemCode = Integer.parseInt(req.getParameter("itemCode"));

        try (Connection connection = dataSource.getConnection()) {
            String sql = "DELETE FROM products WHERE itemCode = ?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setInt(1, itemCode);

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("productMessage", "Product successfully deleted!");
            } else {
                req.getSession().setAttribute("productError", "Failed to delete product!");
            }
            resp.sendRedirect("product");

        } catch (SQLException e) {
            req.getSession().setAttribute("productError", "Failed to delete product!");
            resp.sendRedirect("product");
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int itemCode = Integer.parseInt(req.getParameter("itemCode"));
        String name = req.getParameter("name");
        BigDecimal unitPrice = new BigDecimal(req.getParameter("unitPrice"));
        String description = req.getParameter("description");
        int qtyOnHand = Integer.parseInt(req.getParameter("qtyOnHand"));
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));

        Part imagePart = req.getPart("image");
        InputStream imageInputStream = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            imageInputStream = imagePart.getInputStream();
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql;
            PreparedStatement pstm;

            if (imageInputStream != null) {
                sql = "UPDATE products SET name = ?, unitPrice = ?, description = ?, " +
                        "qtyOnHand = ?, image = ?, categoryId = ? WHERE itemCode = ?";
                pstm = connection.prepareStatement(sql);
                pstm.setBlob(5, imageInputStream);
                pstm.setInt(6, categoryId);
                pstm.setInt(7, itemCode);
            } else {
                sql = "UPDATE products SET name = ?, unitPrice = ?, description = ?, " +
                        "qtyOnHand = ?, categoryId = ? WHERE itemCode = ?";
                pstm = connection.prepareStatement(sql);
                pstm.setInt(5, categoryId);
                pstm.setInt(6, itemCode);
            }

            pstm.setString(1, name);
            pstm.setBigDecimal(2, unitPrice);
            pstm.setString(3, description);
            pstm.setInt(4, qtyOnHand);

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("productMessage", "Product successfully updated!");
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\"}");
            } else {
                req.getSession().setAttribute("productError", "Failed to update product!");
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"error\"}");
            }

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"Database error occurred\"}");
        }
    }
}