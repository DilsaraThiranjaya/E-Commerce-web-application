package lk.ijse.ecommercewebapplication;

import dto.OrderDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "orderServlet", value = "/order")
public class OrderServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection connection = dataSource.getConnection()) {
            // Get total orders
            String totalOrdersSql = "SELECT COUNT(*) as total FROM orders";
            PreparedStatement totalOrdersStmt = connection.prepareStatement(totalOrdersSql);
            ResultSet totalOrdersRs = totalOrdersStmt.executeQuery();
            totalOrdersRs.next();
            req.setAttribute("totalOrders", totalOrdersRs.getInt("total"));

            // Get pending orders
            String pendingOrdersSql = "SELECT COUNT(*) as pending FROM orders WHERE status = 'Pending'";
            PreparedStatement pendingOrdersStmt = connection.prepareStatement(pendingOrdersSql);
            ResultSet pendingOrdersRs = pendingOrdersStmt.executeQuery();
            pendingOrdersRs.next();
            req.setAttribute("pendingOrders", pendingOrdersRs.getInt("pending"));

            // Get today's revenue
            String todayRevenueSql = "SELECT COALESCE(SUM(subTotal + shipingCost), 0) as revenue FROM orders WHERE DATE(date) = CURRENT_DATE";
            PreparedStatement todayRevenueStmt = connection.prepareStatement(todayRevenueSql);
            ResultSet todayRevenueRs = todayRevenueStmt.executeQuery();
            todayRevenueRs.next();
            req.setAttribute("todayRevenue", todayRevenueRs.getBigDecimal("revenue"));

            // Get monthly revenue
            String monthlyRevenueSql = "SELECT COALESCE(SUM(subTotal + shipingCost), 0) as revenue FROM orders WHERE MONTH(date) = MONTH(CURRENT_DATE) AND YEAR(date) = YEAR(CURRENT_DATE)";
            PreparedStatement monthlyRevenueStmt = connection.prepareStatement(monthlyRevenueSql);
            ResultSet monthlyRevenueRs = monthlyRevenueStmt.executeQuery();
            monthlyRevenueRs.next();
            req.setAttribute("monthlyRevenue", monthlyRevenueRs.getBigDecimal("revenue"));

            // Get all orders with customer information
            String sql = "SELECT o.*, u.fullName, u.image FROM orders o " +
                    "JOIN users u ON o.userId = u.userId " +
                    "ORDER BY o.date DESC";
            PreparedStatement pstm = connection.prepareStatement(sql);
            ResultSet resultSet = pstm.executeQuery();

            List<OrderDTO> orderDTOList = new ArrayList<>();

            while (resultSet.next()) {
                OrderDTO orderDTO = new OrderDTO();
                orderDTO.setOrderId(resultSet.getString("orderId"));
                orderDTO.setDate(resultSet.getDate("date"));
                orderDTO.setUserId(resultSet.getInt("userId"));
                orderDTO.setAddress(resultSet.getString("address"));
                orderDTO.setCity(resultSet.getString("city"));
                orderDTO.setState(resultSet.getString("state"));
                orderDTO.setZipCode(resultSet.getString("zipCode"));
                orderDTO.setStatus(resultSet.getString("status"));
                orderDTO.setSubTotal(resultSet.getBigDecimal("subTotal"));
                orderDTO.setShippingCost(resultSet.getBigDecimal("shipingCost"));
                orderDTO.setPaymentMethod(resultSet.getString("paymentMethod"));
                orderDTO.setCustomerName(resultSet.getString("fullName"));
                orderDTO.setCustomerImage(resultSet.getBytes("image"));

                orderDTOList.add(orderDTO);
            }

            req.setAttribute("orderList", orderDTOList);
            req.getRequestDispatcher("admin/orders.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("admin/orders.jsp?error=Unable to load orders.");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderId = req.getParameter("orderId");
        String status = req.getParameter("status");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, status);
            pstm.setString(2, orderId);

            int i = pstm.executeUpdate();

            if (i > 0) {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\"}");
            } else {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"error\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setContentType("application/json");
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
