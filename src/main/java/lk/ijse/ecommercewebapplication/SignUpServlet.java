package lk.ijse.ecommercewebapplication;

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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "signUpServlet", value = "/sign-up-action")
@MultipartConfig
public class SignUpServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("full-name");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirm-password");

        System.out.println(fullName + username + email + phone + address + password + confirmPassword);

        Part imagePart = req.getPart("image");
        InputStream imageInputStream = null;

        if (imagePart != null) {
            imageInputStream = imagePart.getInputStream();
        }

        try (Connection connection = dataSource.getConnection()) {
            String sql1 = "SELECT * FROM users WHERE username=?";
            PreparedStatement pstm1 = connection.prepareStatement(sql1);
            pstm1.setString(1, username);
            ResultSet rs1 = pstm1.executeQuery();

            if (!rs1.next()) {
                String sql2 = "SELECT * FROM users WHERE email=?";
                PreparedStatement pstm2 = connection.prepareStatement(sql2);
                pstm2.setString(1, email);
                ResultSet rs2 = pstm2.executeQuery();

                if (!rs2.next()) {
                    if (password.equals(confirmPassword)) {
                        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

                        String sql3 = "INSERT INTO users (username, email, password, fullName, address, phoneNumber, image)  VALUES (?, ?, ?, ?, ?, ?, ?)";
                        PreparedStatement pstm3 = connection.prepareStatement(sql3);
                        pstm3.setString(1, username);
                        pstm3.setString(2, email);
                        pstm3.setString(3, hashedPassword);
                        pstm3.setString(4, fullName);
                        pstm3.setString(5, address);
                        pstm3.setString(6, phone);

                        if (imageInputStream != null) {
                            pstm3.setBlob(7, imageInputStream);
                        } else {
                            pstm3.setNull(7, java.sql.Types.BLOB);
                        }

                        int i = pstm3.executeUpdate();

                        if (i > 0) {
                            resp.sendRedirect("sign-up.jsp?message=Signed Up Successfully !");
                        } else {
                            resp.sendRedirect("sign-up.jsp?error=Failed to save user !");
                        }
                    } else {
                        resp.sendRedirect("sign-up.jsp?error=Password not match !");
                    }
                } else {
                    resp.sendRedirect("sign-up.jsp?error=Email already exists !");
                }
            } else {
                resp.sendRedirect("sign-up.jsp?error=Username already exists !");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("sign-up.jsp?error=Failed to save user !");
        }
    }
}
