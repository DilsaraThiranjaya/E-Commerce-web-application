package lk.ijse.ecommercewebapplication;

import dto.OrderDTO;
import dto.UserDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.mindrot.jbcrypt.BCrypt;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "profileServlet", value = "/profile")
@MultipartConfig
public class ProfileServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get the logged-in user's email from the session
        String email = (String) req.getSession().getAttribute("userEmail");
        String role = (String) req.getSession().getAttribute("userRole");

        // Ensure the email is not null
        if (email == null || email.isEmpty() && role == null || role.isEmpty()) {
            resp.sendRedirect("log-in.jsp?error=Session expired. Please log in again.");
            return;
        }

        // Retrieve any error or message from the session
        String errorMessage = (String) req.getSession().getAttribute("profileError");
        String successMessage = (String) req.getSession().getAttribute("profileMessage");

        // Build the URL with the parameters if they exist
        StringBuilder redirectUrl = new StringBuilder();

        if (role.equals("Admin")) {
            if (errorMessage != null) {
                redirectUrl.append("admin/admin-profile.jsp?error=").append(URLEncoder.encode(errorMessage, "UTF-8"));
                req.getSession().removeAttribute("profileError"); // Remove after use
            } else if (successMessage != null) {
                redirectUrl.append("admin/admin-profile.jsp?message=").append(URLEncoder.encode(successMessage, "UTF-8"));
                req.getSession().removeAttribute("profileMessage"); // Remove after use
            } else {
                redirectUrl.append("admin/admin-profile.jsp");
            }
        } else {
            if (errorMessage != null) {
                redirectUrl.append("customer/customer-profile.jsp?error=").append(URLEncoder.encode(errorMessage, "UTF-8"));
                req.getSession().removeAttribute("profileError"); // Remove after use
            } else if (successMessage != null) {
                redirectUrl.append("customer/customer-profile.jsp?message=").append(URLEncoder.encode(successMessage, "UTF-8"));
                req.getSession().removeAttribute("profileMessage"); // Remove after use
            } else {
                redirectUrl.append("customer/customer-profile.jsp");
            }
        }

        try (Connection connection = dataSource.getConnection()) {
            if (role.equals("Customer")) {
                getProfileStats(connection, req, resp);
                getOrderList(connection, req, resp);
            }

            // SQL query to fetch the user's details
            String sql = "SELECT * FROM users WHERE email=?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, email);
            ResultSet resultSet = pstm.executeQuery();

            // If the user exists, set their details in a UserDTO object
            if (resultSet.next()) {
                UserDTO user = new UserDTO();
                user.setUserId(resultSet.getInt("userId"));
                user.setUsername(resultSet.getString("username"));
                user.setEmail(resultSet.getString("email"));
                user.setFullName(resultSet.getString("fullName"));
                user.setAddress(resultSet.getString("address"));
                user.setPhoneNumber(resultSet.getString("phoneNumber"));
                user.setRole(resultSet.getString("role"));
                user.setDate(resultSet.getTimestamp("date"));
                user.setStatus(resultSet.getString("status"));
                user.setImage(resultSet.getBytes("image"));

                // Set the user details in the request scope and forward to JSP
                req.setAttribute("user", user);
                req.getRequestDispatcher(String.valueOf(redirectUrl)).forward(req, resp);
            } else {
                // If no user is found, redirect with an error
                resp.sendRedirect("log-in.jsp?error=User not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("log-in.jsp?error=Unable to load profile.");
        }
    }

    private void getOrderList(Connection connection, HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        String userId = (String) req.getSession().getAttribute("userId");

        String sql = "SELECT * FROM orders WHERE userId=?";
        PreparedStatement pstm = connection.prepareStatement(sql);
        pstm.setString(1, userId);
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
            orderDTO.setShippingCost(resultSet.getBigDecimal("shipingCost")); // Note the typo in your column name
            orderDTO.setPaymentMethod(resultSet.getString("paymentMethod"));

            orderDTOList.add(orderDTO);
        }

        req.setAttribute("orderList", orderDTOList);
    }

    private void getProfileStats(Connection connection, HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        String userId = (String) req.getSession().getAttribute("userId");

        String sql = "SELECT \n" +
                "    COUNT(*) AS total_orders,\n" +
                "    SUM(subTotal + shipingCost) AS total_spend,\n" +
                "    SUM(CASE \n" +
                "        WHEN MONTH(date) = MONTH(CURRENT_DATE()) AND YEAR(date) = YEAR(CURRENT_DATE()) THEN 1 \n" +
                "        ELSE 0 \n" +
                "    END) AS orders_current_month\n" +
                "FROM orders\n" +
                "WHERE userId = ?";
        PreparedStatement pstm = connection.prepareStatement(sql);
        pstm.setString(1, userId);
        ResultSet resultSet = pstm.executeQuery();

        if (resultSet.next()) {
            // Fetch and format total orders (string)
            String totalOrders = resultSet.getString("total_orders");
            req.setAttribute("totalOrders", totalOrders);

            if (resultSet.getString("total_spend") != null) {
                // Fetch and format total spend (decimal with Rs.)
                BigDecimal totalSpend = resultSet.getBigDecimal("total_spend");
                String formattedTotalSpend = "Rs. " + totalSpend.setScale(2, RoundingMode.HALF_UP);
                req.setAttribute("totalSpend", formattedTotalSpend);
            } else {
                req.setAttribute("totalSpend", "Rs. 0.00");
            }

            if (resultSet.getString("orders_current_month") != null) {
                // Fetch and format orders in current month (string)
                String ordersCurrentMonth = resultSet.getString("orders_current_month");
                req.setAttribute("ordersCurrentMonth", ordersCurrentMonth);
            } else {
                req.setAttribute("ordersCurrentMonth", "0");
            }
        } else {
            resp.sendRedirect("log-in.jsp?error=Unable to load profile.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        switch (action) {
            case "profile-info-update":
                profileInfoUpdate(req, resp);
                break;
            case "profile-username-update":
                profileUsernameUpdate(req, resp);
                break;
            case "profile-password-update":
                profilePasswordUpdate(req, resp);
        }
    }

    private void profileInfoUpdate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        String userEmail = (String) req.getSession().getAttribute("userEmail");
        String role = (String) req.getSession().getAttribute("userRole");

        if (userEmail == null || userEmail.isEmpty() && role == null || role.isEmpty()) {
            resp.sendRedirect("log-in.jsp?error=Session expired. Please log in again.");
            return;
        }

        Part imagePart = req.getPart("image");
        InputStream imageInputStream = null;

        if (imagePart != null) {
            imageInputStream = imagePart.getInputStream();
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE users SET fullName=?, email=?, address=?, phoneNumber=?, image=? WHERE email=?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, fullName);
            pstm.setString(2, email);
            pstm.setString(3, address);
            pstm.setString(4, phone);

            if (imageInputStream != null) {
                pstm.setBlob(5, imageInputStream);
            } else {
                pstm.setNull(5, java.sql.Types.BLOB);
            }

            pstm.setString(6, userEmail);

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().invalidate();
                req.getSession(true).setAttribute("userEmail", email); // Add the updated email
                req.getSession().setAttribute("userRole", role);
                req.getSession().setAttribute("profileMessage", "Successfully profile information updated.");

                // Reapply the user role
                resp.sendRedirect("profile");
            } else {
                req.getSession().setAttribute("profileError", "Failed to update profile information.");
                resp.sendRedirect("profile");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("profileError", "Failed to update profile information.");
            resp.sendRedirect("profile");
            throw new RuntimeException(e);
        }
    }

    private void profileUsernameUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");

        String userEmail = (String) req.getSession().getAttribute("userEmail");

        if (userEmail == null || userEmail.isEmpty()) {
            resp.sendRedirect("log-in.jsp?error=Session expired. Please log in again.");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE users SET username=? WHERE email=?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, username);
            pstm.setString(2, userEmail);

            int i = pstm.executeUpdate();

            if (i > 0) {
                req.getSession().setAttribute("profileMessage", "Successfully profile username updated.");

                resp.sendRedirect("profile");
            } else {
                req.getSession().setAttribute("profileError", "Failed to update profile username.");
                resp.sendRedirect("profile");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("profileError", "Failed to update profile username.");
            resp.sendRedirect("profile");
            throw new RuntimeException(e);
        }
    }

    private void profilePasswordUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        String userEmail = (String) req.getSession().getAttribute("userEmail");

        if (userEmail == null || userEmail.isEmpty()) {
            resp.sendRedirect("log-in.jsp?error=Session expired. Please log in again.");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.getSession().setAttribute("profileError", "New Passwords do not match.");
            resp.sendRedirect("profile");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT password FROM users WHERE email=?";
            PreparedStatement pstm = connection.prepareStatement(sql);
            pstm.setString(1, userEmail);
            ResultSet resultSet = pstm.executeQuery();

            if (resultSet.next()) {
                if (BCrypt.checkpw(currentPassword, resultSet.getString(1))) {
                    String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                    String sql2 = "UPDATE users SET password=? WHERE email=?";
                    PreparedStatement pstm2 = connection.prepareStatement(sql2);
                    pstm2.setString(1, hashedPassword);
                    pstm2.setString(2, userEmail);

                    int i = pstm2.executeUpdate();

                    if (i > 0) {
                        req.getSession().setAttribute("profileMessage", "Successfully profile password changed.");

                        resp.sendRedirect("profile");
                    } else {
                        req.getSession().setAttribute("profileError", "Failed to change profile password.");
                        resp.sendRedirect("profile");
                    }
                } else {
                    req.getSession().setAttribute("profileError", "Incorrect Password.");
                    resp.sendRedirect("profile");
                }
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("profileError", "Failed to change profile password.");
            resp.sendRedirect("profile");
            throw new RuntimeException(e);
        }
    }
}
