package lk.ijse.ecommercewebapplication;

import lk.ijse.ecommercewebapplication.dto.UserDTO;
import jakarta.annotation.Resource;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.List;

@WebServlet(name = "customerServlet", value = "/customer")
public class CustomerServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("search".equals(action)) {
            handleSearch(req, resp);
            return;
        }

        if ("view".equals(action)) {
            handleViewCustomer(req, resp);
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            
            String statsSql = """
                SELECT 
                    COUNT(*) as total_customers,
                    SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active_customers,
                    SUM(CASE WHEN status = 'Inactive' THEN 1 ELSE 0 END) as inactive_customers,
                    SUM(CASE WHEN MONTH(date) = MONTH(CURRENT_DATE) AND YEAR(date) = YEAR(CURRENT_DATE) THEN 1 ELSE 0 END) as new_customers
                FROM users 
                WHERE role = 'Customer'
            """;

            PreparedStatement statsStmt = connection.prepareStatement(statsSql);
            ResultSet statsRs = statsStmt.executeQuery();

            if (statsRs.next()) {
                req.setAttribute("totalCustomers", statsRs.getInt("total_customers"));
                req.setAttribute("activeCustomers", statsRs.getInt("active_customers"));
                req.setAttribute("inactiveCustomers", statsRs.getInt("inactive_customers"));
                req.setAttribute("newCustomers", statsRs.getInt("new_customers"));
            }

            
            String sql = """
                SELECT u.*, 
                       (SELECT COUNT(*) FROM orders o WHERE o.userId = u.userId) as order_count 
                FROM users u 
                WHERE u.role = 'Customer' 
                ORDER BY u.date DESC
            """;

            PreparedStatement pstm = connection.prepareStatement(sql);
            ResultSet resultSet = pstm.executeQuery();

            List<UserDTO> customerList = new ArrayList<>();

            while (resultSet.next()) {
                UserDTO customer = new UserDTO();
                customer.setUserId(resultSet.getInt("userId"));
                customer.setUsername(resultSet.getString("username"));
                customer.setEmail(resultSet.getString("email"));
                customer.setFullName(resultSet.getString("fullName"));
                customer.setAddress(resultSet.getString("address"));
                customer.setPhoneNumber(resultSet.getString("phoneNumber"));
                customer.setStatus(resultSet.getString("status"));
                customer.setDate(resultSet.getTimestamp("date"));
                customer.setImage(resultSet.getBytes("image"));
                customer.setOrderCount(resultSet.getInt("order_count"));

                customerList.add(customer);
            }

            req.setAttribute("customerList", customerList);
            req.getRequestDispatcher("admin/customers.jsp").forward(req, resp);

        } catch (SQLException e) {
            resp.sendRedirect("admin/customers.jsp?error=Unable to load customers.");
            throw new RuntimeException(e);
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String searchType = req.getParameter("searchType");
        String searchTerm = req.getParameter("searchTerm");
        String status = req.getParameter("status");

        try (Connection connection = dataSource.getConnection()) {
            StringBuilder sql = new StringBuilder("""
                SELECT u.*, 
                       (SELECT COUNT(*) FROM orders o WHERE o.userId = u.userId) as order_count 
                FROM users u 
                WHERE u.role = 'Customer'
            """);

            if (searchTerm != null && !searchTerm.isEmpty()) {
                switch (searchType) {
                    case "name" -> sql.append(" AND u.fullName LIKE ?");
                    case "email" -> sql.append(" AND u.email LIKE ?");
                    case "phone" -> sql.append(" AND u.phoneNumber LIKE ?");
                }
            }

            if (status != null && !status.equals("all")) {
                sql.append(" AND u.status = ?");
            }

            sql.append(" ORDER BY u.date DESC");

            PreparedStatement pstm = connection.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (searchTerm != null && !searchTerm.isEmpty()) {
                pstm.setString(paramIndex++, "%" + searchTerm + "%");
            }

            if (status != null && !status.equals("all")) {
                pstm.setString(paramIndex, status);
            }

            ResultSet resultSet = pstm.executeQuery();
            JsonArrayBuilder customersArray = Json.createArrayBuilder();

            while (resultSet.next()) {
                JsonObjectBuilder customer = Json.createObjectBuilder()
                        .add("userId", resultSet.getInt("userId"))
                        .add("fullName", resultSet.getString("fullName"))
                        .add("email", resultSet.getString("email"))
                        .add("phoneNumber", resultSet.getString("phoneNumber"))
                        .add("status", resultSet.getString("status"))
                        .add("date", resultSet.getTimestamp("date").toString())
                        .add("orderCount", resultSet.getInt("order_count"));

                byte[] image = resultSet.getBytes("image");
                if (image != null) {
                    customer.add("image", Base64.getEncoder().encodeToString(image));
                }

                customersArray.add(customer);
            }

            JsonArray jsonResponse = customersArray.build();
            resp.setContentType("application/json");
            resp.getWriter().write(jsonResponse.toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Database error occurred");
        }
    }

    private void handleViewCustomer(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));

        try (Connection connection = dataSource.getConnection()) {
            
            String customerSql = """
                SELECT u.*, 
                       (SELECT COUNT(*) FROM orders o WHERE o.userId = u.userId) as order_count 
                FROM users u 
                WHERE u.userId = ?
            """;

            PreparedStatement customerStmt = connection.prepareStatement(customerSql);
            customerStmt.setInt(1, userId);
            ResultSet customerRs = customerStmt.executeQuery();

            JsonObjectBuilder response = Json.createObjectBuilder();
            if (customerRs.next()) {
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(customerRs.getTimestamp("date"));

                JsonObjectBuilder customer = Json.createObjectBuilder()
                        .add("userId", customerRs.getInt("userId"))
                        .add("fullName", customerRs.getString("fullName"))
                        .add("email", customerRs.getString("email"))
                        .add("phoneNumber", customerRs.getString("phoneNumber"))
                        .add("address", customerRs.getString("address"))
                        .add("status", customerRs.getString("status"))
                        .add("date", calendar.get(Calendar.YEAR))
                        .add("orderCount", customerRs.getInt("order_count"));

                byte[] image = customerRs.getBytes("image");
                if (image != null) {
                    customer.add("image", Base64.getEncoder().encodeToString(image));
                }

                response.add("customer", customer);

                
                String ordersSql = """
                    SELECT o.orderId, o.date, o.status,
                           (o.subTotal + o.shipingCost) as total
                    FROM orders o 
                    WHERE o.userId = ? 
                    ORDER BY o.date DESC 
                    LIMIT 5
                """;

                PreparedStatement ordersStmt = connection.prepareStatement(ordersSql);
                ordersStmt.setInt(1, userId);
                ResultSet ordersRs = ordersStmt.executeQuery();

                JsonArrayBuilder orders = Json.createArrayBuilder();

                while (ordersRs.next()) {
                    orders.add(Json.createObjectBuilder()
                            .add("orderId", ordersRs.getString("orderId"))
                            .add("date", ordersRs.getDate("date").toString())
                            .add("status", ordersRs.getString("status"))
                            .add("total", ordersRs.getBigDecimal("total"))
                    );
                }

                response.add("orders", orders);
            }

            resp.setContentType("application/json");
            resp.getWriter().write(response.build().toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Database error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("update-status".equals(action)) {
            updateCustomerStatus(req, resp);
        }
    }

    private void updateCustomerStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        String status = req.getParameter("status");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE users SET status = ? WHERE userId = ? AND role = 'Customer'";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, status);
            pstm.setInt(2, userId);

            int result = pstm.executeUpdate();

            JsonObjectBuilder response = Json.createObjectBuilder();
            if (result > 0) {
                response.add("status", "success");
            } else {
                response.add("status", "error");
            }

            resp.setContentType("application/json");
            resp.getWriter().write(response.build().toString());

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Database error occurred");
        }
    }
}