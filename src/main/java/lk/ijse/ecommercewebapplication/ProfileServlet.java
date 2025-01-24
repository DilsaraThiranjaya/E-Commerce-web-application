package lk.ijse.ecommercewebapplication;

import dto.UserDTO;
import jakarta.annotation.Resource;
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("profile-info-update".equalsIgnoreCase(action)) {
            profileInfoUpdate(req, resp);
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
                req.getSession().setAttribute("profileMessage", "Successfully profile updated.");

                // Reapply the user role
                resp.sendRedirect("profile");
            } else {
                req.getSession().setAttribute("profileError", "Failed to update profile.");
                resp.sendRedirect("profile");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("profileError", "Failed to update profile.");
            resp.sendRedirect("profile");
            throw new RuntimeException(e);
        }
    }
}
