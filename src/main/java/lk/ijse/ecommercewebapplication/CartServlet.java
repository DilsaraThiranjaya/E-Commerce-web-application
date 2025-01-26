package lk.ijse.ecommercewebapplication;

import lk.ijse.ecommercewebapplication.dto.CartDetailDTO;
import jakarta.annotation.Resource;
import jakarta.json.Json;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "cartServlet", value = "/cart")
public class CartServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/log-in.jsp");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            
            int cartId = getOrCreateCart(connection, userId);

            
            List<CartDetailDTO> cartItems = getCartItems(connection, cartId);

            
            double subtotal = calculateSubtotal(cartItems);
            double shipping = 350.00; 
            double total = subtotal + shipping;

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("subtotal", subtotal);
            req.setAttribute("shipping", shipping);
            req.setAttribute("total", total);

            req.getRequestDispatcher("customer/cart.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error occurred", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\": \"User not logged in\"}");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            switch (action) {
                case "add":
                    handleAddToCart(req, resp, connection, userId);
                    break;
                case "update":
                    handleUpdateQuantity(req, resp, connection, userId);
                    break;
                case "remove":
                    handleRemoveFromCart(req, resp, connection, userId);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error occurred", e);
        }
    }

    private void handleAddToCart(HttpServletRequest req, HttpServletResponse resp, Connection connection, String userId)
            throws SQLException, IOException {
        int itemCode = Integer.parseInt(req.getParameter("itemCode"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));

        int cartId = getOrCreateCart(connection, userId);

        
        String checkSql = "SELECT quantity FROM cart_details WHERE cartId = ? AND itemCode = ?";
        try (PreparedStatement pstm = connection.prepareStatement(checkSql)) {
            pstm.setInt(1, cartId);
            pstm.setInt(2, itemCode);
            ResultSet rs = pstm.executeQuery();

            if (rs.next()) {
                
                int currentQty = rs.getInt("quantity");
                String updateSql = "UPDATE cart_details SET quantity = ? WHERE cartId = ? AND itemCode = ?";
                try (PreparedStatement updatePstm = connection.prepareStatement(updateSql)) {
                    updatePstm.setInt(1, currentQty + quantity);
                    updatePstm.setInt(2, cartId);
                    updatePstm.setInt(3, itemCode);
                    updatePstm.executeUpdate();
                }
            } else {
                
                String insertSql = "INSERT INTO cart_details (cartId, itemCode, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement insertPstm = connection.prepareStatement(insertSql)) {
                    insertPstm.setInt(1, cartId);
                    insertPstm.setInt(2, itemCode);
                    insertPstm.setInt(3, quantity);
                    insertPstm.executeUpdate();
                }
            }
        }

        resp.setContentType("application/json");
        resp.getWriter().write("{\"success\": true}");
    }

    private void handleUpdateQuantity(HttpServletRequest req, HttpServletResponse resp, Connection connection, String userId)
            throws SQLException, IOException {
        int itemCode = Integer.parseInt(req.getParameter("itemCode"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        int cartId = getOrCreateCart(connection, userId);

        String sql = "UPDATE cart_details SET quantity = ? WHERE cartId = ? AND itemCode = ?";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setInt(1, quantity);
            pstm.setInt(2, cartId);
            pstm.setInt(3, itemCode);
            pstm.executeUpdate();
        }

        
        List<CartDetailDTO> cartItems = getCartItems(connection, cartId);
        double subtotal = calculateSubtotal(cartItems);
        double shipping = 350.00;
        double total = subtotal + shipping;

        JsonObjectBuilder response = Json.createObjectBuilder()
                .add("success", true)
                .add("subtotal", subtotal)
                .add("shipping", shipping)
                .add("total", total);

        resp.setContentType("application/json");
        resp.getWriter().write(response.build().toString());
    }

    private void handleRemoveFromCart(HttpServletRequest req, HttpServletResponse resp, Connection connection, String userId)
            throws SQLException, IOException {
        int itemCode = Integer.parseInt(req.getParameter("itemCode"));
        int cartId = getOrCreateCart(connection, userId);

        String sql = "DELETE FROM cart_details WHERE cartId = ? AND itemCode = ?";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setInt(1, cartId);
            pstm.setInt(2, itemCode);
            pstm.executeUpdate();
        }

        resp.setContentType("application/json");
        resp.getWriter().write("{\"success\": true}");
    }

    private int getOrCreateCart(Connection connection, String userId) throws SQLException {
        
        String selectSql = "SELECT id FROM cart WHERE userId = ?";
        try (PreparedStatement pstm = connection.prepareStatement(selectSql)) {
            pstm.setString(1, userId);
            ResultSet rs = pstm.executeQuery();

            if (rs.next()) {
                return rs.getInt("id");
            }
        }

        
        String insertSql = "INSERT INTO cart (userId) VALUES (?)";
        try (PreparedStatement pstm = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            pstm.setString(1, userId);
            pstm.executeUpdate();

            ResultSet rs = pstm.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        throw new SQLException("Failed to create cart");
    }

    private List<CartDetailDTO> getCartItems(Connection connection, int cartId) throws SQLException {
        List<CartDetailDTO> items = new ArrayList<>();

        String sql = "SELECT cd.*, p.name, p.unitPrice, p.description, p.image " +
                "FROM cart_details cd " +
                "JOIN products p ON cd.itemCode = p.itemCode " +
                "WHERE cd.cartId = ?";

        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setInt(1, cartId);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                CartDetailDTO item = new CartDetailDTO();
                item.setCartId(cartId);
                item.setItemCode(rs.getInt("itemCode"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductName(rs.getString("name"));
                item.setUnitPrice(rs.getDouble("unitPrice"));
                item.setDescription(rs.getString("description"));
                item.setImage(rs.getBytes("image"));
                items.add(item);
            }
        }

        return items;
    }

    private double calculateSubtotal(List<CartDetailDTO> items) {
        return items.stream()
                .mapToDouble(item -> item.getUnitPrice() * item.getQuantity())
                .sum();
    }
}