package lk.ijse.ecommercewebapplication;

import jakarta.annotation.Resource;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.ecommercewebapplication.dto.OrderDTO;
import lk.ijse.ecommercewebapplication.dto.OrderDetailDTO;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "orderServlet", value = "/order")
public class OrderServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            handleSearch(req, resp);
            return;
        } else if ("view".equals(action)) {
            handleViewOrder(req, resp);
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            List<OrderDTO> orderList = getAllOrders(connection);
            req.setAttribute("orderList", orderList);

            req.setAttribute("totalOrders", getTotalOrders(connection));
            req.setAttribute("pendingOrders", getPendingOrders(connection));
            req.setAttribute("todayRevenue", getTodayRevenue(connection));
            req.setAttribute("monthlyRevenue", getMonthlyRevenue(connection));

            req.getRequestDispatcher("admin/orders.jsp").forward(req, resp);
        } catch (SQLException e) {
            resp.sendRedirect("admin/orders.jsp?error=Unable to load orders.");
            throw new RuntimeException(e);
        }
    }

    private void handleViewOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String orderId = req.getParameter("orderId");

        try (Connection connection = dataSource.getConnection()) {

            String sql = "SELECT o.*, u.fullName, u.email, u.phoneNumber FROM orders o " +
                    "JOIN users u ON o.userId = u.userId " +
                    "WHERE o.orderId = ?";

            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, orderId);
            ResultSet rs = pstm.executeQuery();

            if (rs.next()) {
                JsonObjectBuilder orderBuilder = Json.createObjectBuilder()
                        .add("orderId", rs.getString("orderId"))
                        .add("customerName", rs.getString("fullName"))
                        .add("customerEmail", rs.getString("email"))
                        .add("customerPhone", rs.getString("phoneNumber"))
                        .add("address", rs.getString("address"))
                        .add("city", rs.getString("city"))
                        .add("state", rs.getString("state"))
                        .add("zipCode", rs.getString("zipCode"))
                        .add("subTotal", rs.getBigDecimal("subTotal").toString())
                        .add("shippingCost", rs.getBigDecimal("shipingCost").toString())
                        .add("total", rs.getBigDecimal("subTotal").add(rs.getBigDecimal("shipingCost")).toString());

                // Get order items
                String itemsSql = "SELECT od.*, p.name as productName, p.unitPrice " +
                        "FROM order_details od " +
                        "JOIN products p ON od.itemCode = p.itemCode " +
                        "WHERE od.orderId = ?";

                PreparedStatement itemsPstm = connection.prepareStatement(itemsSql);
                itemsPstm.setString(1, orderId);
                ResultSet itemsRs = itemsPstm.executeQuery();

                JsonArrayBuilder itemsArray = Json.createArrayBuilder();
                while (itemsRs.next()) {
                    itemsArray.add(Json.createObjectBuilder()
                            .add("productName", itemsRs.getString("productName"))
                            .add("quantity", itemsRs.getInt("quantity"))
                            .add("unitPrice", itemsRs.getBigDecimal("unitPrice").toString()));
                }

                orderBuilder.add("items", itemsArray);

                resp.setContentType("application/json");
                resp.getWriter().write(orderBuilder.build().toString());
            } else {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\": \"Order not found\"}");
            }
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Database error occurred\"}");
            e.printStackTrace();
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String searchType = req.getParameter("searchType");
        String searchValue = req.getParameter("searchValue");
        String status = req.getParameter("status");
        String date = req.getParameter("date");

        try (Connection connection = dataSource.getConnection()) {
            StringBuilder sql = new StringBuilder("SELECT o.*, u.fullName, u.image FROM orders o " +
                    "JOIN users u ON o.userId = u.userId WHERE 1=1");

            if (searchType != null && searchValue != null && !searchValue.trim().isEmpty()) {
                if ("order".equals(searchType)) {
                    sql.append(" AND o.orderId LIKE ?");
                } else if ("customer".equals(searchType)) {
                    sql.append(" AND u.fullName LIKE ?");
                }
            }

            if (status != null && !status.equals("all")) {
                sql.append(" AND o.status = ?");
            }

            if (date != null && !date.trim().isEmpty()) {
                sql.append(" AND DATE(o.date) = ?");
            }

            PreparedStatement pstm = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                pstm.setString(paramIndex++, "%" + searchValue + "%");
            }
            if (status != null && !status.equals("all")) {
                pstm.setString(paramIndex++, status);
            }
            if (date != null && !date.trim().isEmpty()) {
                pstm.setDate(paramIndex, Date.valueOf(date));
            }

            ResultSet rs = pstm.executeQuery();
            JsonArrayBuilder ordersArray = Json.createArrayBuilder();

            while (rs.next()) {
                JsonObjectBuilder order = Json.createObjectBuilder()
                        .add("orderId", rs.getString("orderId"))
                        .add("customerName", rs.getString("fullName"))
                        .add("date", rs.getDate("date").toString())
                        .add("total", rs.getBigDecimal("subTotal").add(rs.getBigDecimal("shipingCost")).toString())
                        .add("status", rs.getString("status"))
                        .add("paymentMethod", rs.getString("paymentMethod"));

                byte[] image = rs.getBytes("image");
                if (image != null) {
                    order.add("customerImage", java.util.Base64.getEncoder().encodeToString(image));
                }

                ordersArray.add(order);
            }

            resp.setContentType("application/json");
            resp.getWriter().write(ordersArray.build().toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Database error occurred");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderId = req.getParameter("orderId");
        String newStatus = req.getParameter("status");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, newStatus);
            pstm.setString(2, orderId);

            int result = pstm.executeUpdate();

            resp.setContentType("application/json");
            if (result > 0) {
                resp.getWriter().write("{\"success\": true}");
            } else {
                System.out.println("Order update failed");
                resp.getWriter().write("{\"success\": false}");
            }
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\": false, \"error\": \"Database error\"}");
        }
    }

    private List<OrderDTO> getAllOrders(Connection connection) throws SQLException {
        List<OrderDTO> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.fullName, u.image FROM orders o " +
                "JOIN users u ON o.userId = u.userId";

        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
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
                order.setOrderDetails(getOrderDetails(connection, order.getOrderId()));

                orders.add(order);
            }
        }
        return orders;
    }

    private List<OrderDetailDTO> getOrderDetails(Connection connection, String orderId) throws SQLException {
        List<OrderDetailDTO> details = new ArrayList<>();
        String sql = "SELECT od.*, p.name, p.unitPrice FROM order_details od " +
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
                detail.setProductName(rs.getString("name"));
                detail.setUnitPrice(rs.getBigDecimal("unitPrice"));

                details.add(detail);
            }
        }
        return details;
    }

    private int getTotalOrders(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM orders";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    private int getPendingOrders(Connection connection) throws SQLException {
        String sql = "SELECT COUNT(*) as pending FROM orders WHERE status = 'Pending'";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                return rs.getInt("pending");
            }
        }
        return 0;
    }

    private BigDecimal getTodayRevenue(Connection connection) throws SQLException {
//        String sql = "SELECT SUM(subTotal + shipingCost) as revenue FROM orders " +
//                "WHERE DATE(date) = CURRENT_DATE AND status = 'Completed'";
        String sql = "SELECT COALESCE(SUM(subTotal + shipingCost), 0) as revenue FROM orders WHERE DATE(date) = CURRENT_DATE";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal("revenue");
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    private BigDecimal getMonthlyRevenue(Connection connection) throws SQLException {
//        String sql = "SELECT SUM(subTotal + shipingCost) as revenue FROM orders " +
//                "WHERE MONTH(date) = MONTH(CURRENT_DATE) " +
//                "AND YEAR(date) = YEAR(CURRENT_DATE) " +
//                "AND status = 'Completed'";
        String sql = "SELECT COALESCE(SUM(subTotal + shipingCost), 0) as revenue FROM orders WHERE MONTH(date) = MONTH(CURRENT_DATE) AND YEAR(date) = YEAR(CURRENT_DATE)";
        try (PreparedStatement pstm = connection.prepareStatement(sql)) {
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal("revenue");
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }
}