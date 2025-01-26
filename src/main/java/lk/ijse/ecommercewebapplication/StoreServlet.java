package lk.ijse.ecommercewebapplication;

import lk.ijse.ecommercewebapplication.dto.ProductDTO;
import lk.ijse.ecommercewebapplication.dto.CategoryDTO;
import jakarta.annotation.Resource;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@WebServlet(name = "storeServlet", value = "/store")
public class StoreServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            handleSearch(req, resp);
            return;
        } else if ("filter".equals(action)) {
            handleFilter(req, resp);
            return;
        } else if ("category".equals(action)) {
            handleCategoryFilter(req, resp);
            return;
        }

        // Default: Load all products and categories
        try (Connection connection = dataSource.getConnection()) {
            List<ProductDTO> products = getAllProducts(connection);
            List<CategoryDTO> categories = getAllCategories(connection);

            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("customer/store.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect("customer/store.jsp?error=Failed to load products");
            throw new RuntimeException(e);
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String searchTerm = req.getParameter("term");
        resp.setContentType("application/json");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT p.*, c.name as categoryName FROM products p " +
                    "JOIN categories c ON p.categoryId = c.id " +
                    "WHERE p.name LIKE ? OR c.name LIKE ?";

            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, "%" + searchTerm + "%");
            pstm.setString(2, "%" + searchTerm + "%");

            ResultSet rs = pstm.executeQuery();
            JsonArrayBuilder productsArray = Json.createArrayBuilder();

            while (rs.next()) {
                JsonObjectBuilder product = Json.createObjectBuilder()
                        .add("itemCode", rs.getInt("itemCode"))
                        .add("name", rs.getString("name"))
                        .add("price", rs.getDouble("unitPrice"))
                        .add("description", rs.getString("description"))
                        .add("qtyOnHand", rs.getInt("qtyOnHand"))
                        .add("categoryName", rs.getString("categoryName"))
                        .add("image", Base64.getEncoder().encodeToString(rs.getBytes("image")));

                productsArray.add(product);
            }

            resp.getWriter().write(productsArray.build().toString());
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Database error occurred\"}");
        }
    }

    private void handleFilter(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        double maxPrice = Double.parseDouble(req.getParameter("maxPrice"));
        boolean inStock = Boolean.parseBoolean(req.getParameter("inStock"));
        boolean outOfStock = Boolean.parseBoolean(req.getParameter("outOfStock"));

        resp.setContentType("application/json");

        try (Connection connection = dataSource.getConnection()) {
            StringBuilder sql = new StringBuilder(
                    "SELECT p.*, c.name as categoryName FROM products p " +
                            "JOIN categories c ON p.categoryId = c.id " +
                            "WHERE p.unitPrice <= ?"
            );

            if (inStock && !outOfStock) {
                sql.append(" AND p.qtyOnHand > 0");
            } else if (!inStock && outOfStock) {
                sql.append(" AND p.qtyOnHand = 0");
            }

            PreparedStatement pstm = connection.prepareStatement(sql.toString());
            pstm.setDouble(1, maxPrice);

            ResultSet rs = pstm.executeQuery();
            JsonArrayBuilder productsArray = Json.createArrayBuilder();

            while (rs.next()) {
                JsonObjectBuilder product = Json.createObjectBuilder()
                        .add("itemCode", rs.getInt("itemCode"))
                        .add("name", rs.getString("name"))
                        .add("price", rs.getDouble("unitPrice"))
                        .add("description", rs.getString("description"))
                        .add("qtyOnHand", rs.getInt("qtyOnHand"))
                        .add("categoryName", rs.getString("categoryName"))
                        .add("image", Base64.getEncoder().encodeToString(rs.getBytes("image")));

                productsArray.add(product);
            }

            resp.getWriter().write(productsArray.build().toString());
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Database error occurred\"}");
        }
    }

    private void handleCategoryFilter(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        resp.setContentType("application/json");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT p.*, c.name as categoryName FROM products p " +
                    "JOIN categories c ON p.categoryId = c.id " +
                    "WHERE p.categoryId = ?";

            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setInt(1, categoryId);

            ResultSet rs = pstm.executeQuery();
            JsonArrayBuilder productsArray = Json.createArrayBuilder();

            while (rs.next()) {
                JsonObjectBuilder product = Json.createObjectBuilder()
                        .add("itemCode", rs.getInt("itemCode"))
                        .add("name", rs.getString("name"))
                        .add("price", rs.getDouble("unitPrice"))
                        .add("description", rs.getString("description"))
                        .add("qtyOnHand", rs.getInt("qtyOnHand"))
                        .add("categoryName", rs.getString("categoryName"))
                        .add("image", Base64.getEncoder().encodeToString(rs.getBytes("image")));

                productsArray.add(product);
            }

            resp.getWriter().write(productsArray.build().toString());
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Database error occurred\"}");
        }
    }

    private List<ProductDTO> getAllProducts(Connection connection) throws SQLException {
        List<ProductDTO> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as categoryName FROM products p " +
                "JOIN categories c ON p.categoryId = c.id";

        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setItemCode(rs.getInt("itemCode"));
                product.setName(rs.getString("name"));
                product.setUnitPrice(BigDecimal.valueOf(rs.getDouble("unitPrice")));
                product.setDescription(rs.getString("description"));
                product.setQtyOnHand(rs.getInt("qtyOnHand"));
                product.setImage(rs.getBytes("image"));
                product.setCategoryId(rs.getInt("categoryId"));
                product.setCategoryName(rs.getString("categoryName"));

                products.add(product);
            }
        }

        return products;
    }

    private List<CategoryDTO> getAllCategories(Connection connection) throws SQLException {
        List<CategoryDTO> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE status = 'Active'";

        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                CategoryDTO category = new CategoryDTO();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setStatus(rs.getString("status"));
                category.setIcon(rs.getBytes("icon"));

                categories.add(category);
            }
        }

        return categories;
    }
}