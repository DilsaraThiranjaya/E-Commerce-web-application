package lk.ijse.ecommercewebapplication;

import dto.CategoryDTO;
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
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@WebServlet(name = "categoryServlet", value = "/category")
@MultipartConfig
public class CategoryServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            String name = req.getParameter("name");
            resp.setContentType("application/json");

            try (Connection connection = dataSource.getConnection()) {
                String sql = "SELECT * FROM categories WHERE name LIKE ?";
                PreparedStatement pstm = connection.prepareStatement(sql);
                pstm.setString(1, "%" + name + "%"); // Use LIKE for partial matching

                ResultSet resultSet = pstm.executeQuery();
                JsonArrayBuilder allCategory = Json.createArrayBuilder();

                while (resultSet.next()) { // Use while to process all matching results
                    String id = resultSet.getString("id");
                    String desc = resultSet.getString("description");
                    String status = resultSet.getString("status");
                    byte[] icon = resultSet.getBytes("icon");

                    JsonObjectBuilder categoryBuilder = Json.createObjectBuilder();
                    categoryBuilder.add("id", id);
                    categoryBuilder.add("name", resultSet.getString("name"));
                    categoryBuilder.add("desc", desc);
                    categoryBuilder.add("status", status);
                    categoryBuilder.add("icon", Base64.getEncoder().encodeToString(icon));

                    allCategory.add(categoryBuilder.build());
                }

                JsonArray jsonResponse = allCategory.build();
                resp.getWriter().write(jsonResponse.toString());

            } catch (SQLException e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("Database error occurred");
                e.printStackTrace(); // Log for server-side tracking
            }
            return;
        }


            String successMessage = (String) req.getSession().getAttribute("categoryMessage");
        String errorMessage = (String) req.getSession().getAttribute("categoryError");

        // Build the URL with the parameters if they exist
        StringBuilder redirectUrl = new StringBuilder();

        if (errorMessage != null) {
            redirectUrl.append("admin/categories.jsp?error=").append(URLEncoder.encode(errorMessage, "UTF-8"));
            req.getSession().removeAttribute("categoryError");
        } else if (successMessage != null) {
            redirectUrl.append("admin/categories.jsp?message=").append(URLEncoder.encode(successMessage, "UTF-8"));
            req.getSession().removeAttribute("categoryMessage");
        } else {
            redirectUrl.append("admin/categories.jsp");
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT * FROM categories";
            PreparedStatement pstm = connection.prepareStatement(sql);
            ResultSet resultSet = pstm.executeQuery();

            List<CategoryDTO> categoryDTOList = new ArrayList<>();

            while (resultSet.next()) {
                CategoryDTO categoryDTO = new CategoryDTO();
                categoryDTO.setId(resultSet.getInt("id"));
                categoryDTO.setName(resultSet.getString("name"));
                categoryDTO.setDescription(resultSet.getString("description"));
                categoryDTO.setStatus(resultSet.getString("status"));
                categoryDTO.setIcon(resultSet.getBytes("icon"));

                categoryDTOList.add(categoryDTO);
            }

            req.setAttribute("totalCategories", getTotalCategories(connection));
            req.setAttribute("activeCategories", getActiveCategories(connection));
            req.setAttribute("productsCategorized", getProductsCategorized(connection));
            req.setAttribute("uncategorizedProducts", getUncategorizedProducts(connection));

            req.setAttribute("categoryList", categoryDTOList);
            req.getRequestDispatcher(String.valueOf(redirectUrl)).forward(req, resp);

        } catch (SQLException e) {
            resp.sendRedirect("admin/categories.jsp?error=Unable to load categories.");
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        switch (action) {
            case "add-category":
                addCategory(req, resp);
                break;
            case "delete-category":
                deleteCategory(req, resp);
        }
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String categoryId = req.getParameter("id");
        System.out.println(categoryId);

        try (Connection connection = dataSource.getConnection()) {
            String sql = "DELETE FROM categories WHERE id = ?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setInt(1, Integer.parseInt(categoryId));

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("categoryMessage", "Category successfully deleted !");
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\"}");
                resp.sendRedirect("category");
            } else {
                req.getSession().setAttribute("categoryError", "Failed to delete category !");
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"error\"}");
                resp.sendRedirect("category");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("categoryError", "Failed to delete category !");
            resp.sendRedirect("category");
            throw new RuntimeException(e);
        }
    }

    private void addCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String status = req.getParameter("status");

        Part iconPart = req.getPart("icon");
        InputStream iconInputStream = null;

        if (iconPart != null) {
            iconInputStream = iconPart.getInputStream();
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO categories (name, description, status, icon) VALUES (?,?,?,?)";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, name);
            pstm.setString(2, description);
            pstm.setString(3, status);

            if (iconInputStream != null) {
                pstm.setBlob(4, iconInputStream);
            } else {
                pstm.setNull(4, java.sql.Types.BLOB);
            }

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("categoryMessage", "Category successfully added !");
                resp.sendRedirect("category");
            } else {
                req.getSession().setAttribute("categoryError", "Failed to add category !");
                resp.sendRedirect("category");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("categoryError", "Failed to add category !");
            resp.sendRedirect("category");
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Read the incoming JSON data (or form data, as you send it as FormData)
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String status = req.getParameter("status");

        Part iconPart = req.getPart("icon");  // If an icon is uploaded
        InputStream iconInputStream = null;

        if (iconPart != null) {
            iconInputStream = iconPart.getInputStream();
        }

        try (Connection connection = dataSource.getConnection()) {
            // Prepare the SQL query to update the category
            String sql = "UPDATE categories SET name = ?, description = ?, status = ?, icon = ? WHERE id = ?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, name);
            pstm.setString(2, description);
            pstm.setString(3, status);

            // If an icon is uploaded, use it; otherwise, set it to null
            if (iconInputStream != null) {
                pstm.setBlob(4, iconInputStream);
            } else {
                pstm.setNull(4, java.sql.Types.BLOB);
            }

            pstm.setInt(5, categoryId);

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("categoryMessage", "Category successfully updated !");
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\"}");
                resp.sendRedirect("category");

            } else {
                req.getSession().setAttribute("categoryError", "Failed to update category !");
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"error\"}");
                resp.sendRedirect("category");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("categoryError", "Failed to update category !");
            resp.sendRedirect("category");
        }
    }

    private int getTotalCategories(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM categories";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    private int getActiveCategories(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) as active FROM categories WHERE status = 'Active'";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("active");
            }
        }
        return 0;
    }

    private int getProductsCategorized(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM products";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    private int getUncategorizedProducts(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) as uncategorized FROM products WHERE categoryId NOT IN (SELECT id FROM categories)";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("uncategorized");
            }
        }
        return 0;
    }

}
