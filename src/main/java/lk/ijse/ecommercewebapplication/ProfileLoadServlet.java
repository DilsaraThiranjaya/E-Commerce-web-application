package lk.ijse.ecommercewebapplication;

import dto.UserDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet(name = "profileLoadServlet", value = "/profile-load")
public class ProfileLoadServlet extends HttpServlet {
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

        try (Connection connection = dataSource.getConnection()) {
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

//                LocalDateTime dateTime = resultSet.getBytes("date");
//                String year = String.valueOf(dateTime.getYear());

                // Set the user details in the request scope and forward to JSP
                req.setAttribute("user", user);

                if (role.equals("Admin")) {
                    req.getRequestDispatcher("admin/admin-profile.jsp").forward(req, resp);
                } else {
                    req.getRequestDispatcher("customer/customer-profile.jsp").forward(req, resp);
                }
            } else {
                // If no user is found, redirect with an error
                resp.sendRedirect("log-in.jsp?error=User not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("log-in.jsp?error=Unable to load profile.");
        }
    }
}
