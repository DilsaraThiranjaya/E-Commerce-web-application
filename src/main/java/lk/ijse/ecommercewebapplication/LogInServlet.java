package lk.ijse.ecommercewebapplication;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "logInServlet", value = "/log-in-action")
public class LogInServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String hashPassword = req.getParameter("password");

        try (Connection connection = dataSource.getConnection()) {
            String sql1 = "SELECT password FROM users WHERE email=?";
            PreparedStatement pstm1 = connection.prepareStatement(sql1);
            pstm1.setString(1, email);
            ResultSet resultSet = pstm1.executeQuery();

            if (resultSet.next()) {
                if (BCrypt.checkpw(hashPassword, resultSet.getString("password"))) {
                    resp.sendRedirect("index.jsp");
                } else {
                    resp.sendRedirect("log-in.jsp?error=Incorrect password !");
                }
            } else {
                resp.sendRedirect("log-in.jsp?error=Incorrect email !");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("log-in.jsp?error=User login Failed !");
        }
    }
}
