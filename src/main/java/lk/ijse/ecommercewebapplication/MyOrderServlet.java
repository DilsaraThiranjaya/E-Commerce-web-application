package lk.ijse.ecommercewebapplication;

import lk.ijse.ecommercewebapplication.dto.OrderDTO;
import lk.ijse.ecommercewebapplication.dto.OrderDetailDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "orderServlet", value = "/myOrders")
public class MyOrderServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect("log-in.jsp");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            // Get order statistics
            req.setAttribute("totalOrders", getTotalOrders(connection, userId));
            req.setAttribute("activeOrders", getActiveOrders(connection, userId));
            req.setAttribute("totalSpent", getTotalSpent(connection, userId));
            req.setAttribute("lastOrderDate", getLastOrderDate(connection, userId));

            // Get all orders for the user
            List<OrderDTO> orders = getUserOrders(connection, userId);
            req.setAttribute("orders", orders);

            req.getRequestDispatcher("customer/my-orders.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("error.jsp");
        }
    }

    private int getTotalOrders(Connection connection, String userId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM orders WHERE userId = ?";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setString(1, userId);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    private int getActiveOrders(Connection connection, String userId) throws SQLException {
        String sql = "SELECT COUNT(*) as active FROM orders WHERE userId = ? AND status = 'Pending'";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setString(1, userId);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("active");
            }
        }
        return 0;
    }

    private BigDecimal getTotalSpent(Connection connection, String userId) throws SQLException {
        String sql = "SELECT SUM(subTotal + shipingCost) as total FROM orders WHERE userId = ?";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setString(1, userId);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total") != null ? rs.getBigDecimal("total") : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    private String getLastOrderDate(Connection connection, String userId) throws SQLException {
        String sql = "SELECT date FROM orders WHERE userId = ? ORDER BY date DESC LIMIT 1";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setString(1, userId);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getDate("date").toString();
            }
        }
        return "No orders";
    }

    private List<OrderDTO> getUserOrders(Connection connection, String userId) throws SQLException {
        List<OrderDTO> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.fullName, u.image FROM orders o " +
                "JOIN users u ON o.userId = u.userId " +
                "WHERE o.userId = ? " +
                "ORDER BY o.date DESC";

        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setString(1, userId);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                OrderDTO order = new OrderDTO();
                order.setOrderId(rs.getString("orderId"));
                order.setDate(rs.getDate("date"));
                order.setUserId(rs.getInt("userId"));
                order.setAddress(rs.getString("address"));
                order.setCity(rs.getString("city"));
                order.setState(rs.getString("state"));
                order.setZipCode(rs.getString("zipCode"));
                order.setStatus(rs.getString("status"));
                order.setSubTotal(rs.getBigDecimal("subTotal"));
                order.setShippingCost(rs.getBigDecimal("shipingCost"));
                order.setPaymentMethod(rs.getString("paymentMethod"));
                order.setCustomerName(rs.getString("fullName"));
                order.setCustomerImage(rs.getBytes("image"));

                // Get order details
                order.setOrderDetails(getOrderDetails(connection, order.getOrderId()));
                orders.add(order);
            }
        }
        return orders;
    }

    private List<OrderDetailDTO> getOrderDetails(Connection connection, String orderId) throws SQLException {
        List<OrderDetailDTO> details = new ArrayList<>();
        String sql = "SELECT od.*, p.name as productName, p.unitPrice " +
                "FROM order_details od " +
                "JOIN products p ON od.itemCode = p.itemCode " +
                "WHERE od.orderId = ?";

        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            pstm.setString(1, orderId);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                OrderDetailDTO detail = new OrderDetailDTO();
                detail.setOrderId(rs.getString("orderId"));
                detail.setItemCode(rs.getInt("itemCode"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setProductName(rs.getString("productName"));
                detail.setUnitPrice(rs.getBigDecimal("unitPrice"));
                details.add(detail);
            }
        }
        return details;
    }
}