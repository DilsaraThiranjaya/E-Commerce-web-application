package lk.ijse.ecommercewebapplication;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.ecommercewebapplication.dto.CartDTO;
import lk.ijse.ecommercewebapplication.dto.CartDetailDTO;
import lk.ijse.ecommercewebapplication.dto.OrderDTO;
import lk.ijse.ecommercewebapplication.dto.OrderDetailDTO;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "checkOutServlet", value = "/checkout")
public class CheckOutServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect("login");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            // Get cart and its details
            CartDTO cart = getCart(connection, userId);
            if (cart == null) {
                resp.sendRedirect("cart?error=No items in cart");
                return;
            }

            List<CartDetailDTO> cartDetails = getCartDetails(connection, cart.getId());
            if (cartDetails.isEmpty()) {
                resp.sendRedirect("cart?error=No items in cart");
                return;
            }

            // Convert cart details to order details
            List<OrderDetailDTO> orderDetails = new ArrayList<>();
            BigDecimal subtotal = BigDecimal.ZERO;

            for (CartDetailDTO cartDetail : cartDetails) {
                OrderDetailDTO orderDetail = new OrderDetailDTO();
                orderDetail.setItemCode(cartDetail.getItemCode());
                orderDetail.setQuantity(cartDetail.getQuantity());
                orderDetail.setProductName(cartDetail.getProductName());
                orderDetail.setUnitPrice(BigDecimal.valueOf(cartDetail.getUnitPrice()));

                BigDecimal itemTotal = orderDetail.getUnitPrice().multiply(BigDecimal.valueOf(orderDetail.getQuantity()));
                subtotal = subtotal.add(itemTotal);

                orderDetails.add(orderDetail);
            }

            // Get user details
            String userSql = "SELECT fullName, image FROM users WHERE userId = ?";
            PreparedStatement userStmt = connection.prepareStatement(userSql);
            userStmt.setString(1, userId);
            ResultSet userRs = userStmt.executeQuery();

            String customerName = "";
            byte[] customerImage = null;
            if (userRs.next()) {
                customerName = userRs.getString("fullName");
                customerImage = userRs.getBytes("image");
            }

            // Calculate totals
            BigDecimal shippingCost = new BigDecimal("29.99");
            BigDecimal total = subtotal.add(shippingCost);

            // Create OrderDTO for the session
            OrderDTO orderDTO = new OrderDTO();
            orderDTO.setUserId(Integer.parseInt(userId));
            orderDTO.setSubTotal(subtotal);
            orderDTO.setShippingCost(shippingCost);
            orderDTO.setOrderDetails(orderDetails);
            orderDTO.setCustomerName(customerName);
            orderDTO.setCustomerImage(customerImage);

            // Store in session for order processing
            session.setAttribute("orderDTO", orderDTO);
            session.setAttribute("cartId", cart.getId());

            // Set attributes for the JSP
            req.setAttribute("orderDTO", orderDTO);
            req.setAttribute("total", total);
            req.setAttribute("cartDetails", cartDetails);

            req.getRequestDispatcher("customer/check-out.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("cart?error=Error loading checkout");
        }
    }

    private CartDTO getCart(Connection connection, String userId) throws SQLException {
        String sql = "SELECT id FROM cart WHERE userId = ?";
        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            CartDTO cart = new CartDTO();
            cart.setId(rs.getInt("id"));
            cart.setUserId(Integer.parseInt(userId));
            return cart;
        }
        return null;
    }

    private List<CartDetailDTO> getCartDetails(Connection connection, int cartId) throws SQLException {
        String sql = "SELECT cd.*, p.name as productName, p.unitPrice, p.description, p.image " +
                "FROM cart_details cd " +
                "JOIN products p ON cd.itemCode = p.itemCode " +
                "WHERE cd.cartId = ?";

        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setInt(1, cartId);
        ResultSet rs = pstmt.executeQuery();

        List<CartDetailDTO> details = new ArrayList<>();
        while (rs.next()) {
            CartDetailDTO detail = new CartDetailDTO();
            detail.setCartId(cartId);
            detail.setItemCode(rs.getInt("itemCode"));
            detail.setQuantity(rs.getInt("quantity"));
            detail.setProductName(rs.getString("productName"));
            detail.setUnitPrice(rs.getDouble("unitPrice"));
            detail.setDescription(rs.getString("description"));
            detail.setImage(rs.getBytes("image"));
            details.add(detail);
        }
        return details;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userId");
        OrderDTO orderDTO = (OrderDTO) session.getAttribute("orderDTO");
        Integer cartId = (Integer) session.getAttribute("cartId");

        if (userId == null || orderDTO == null || cartId == null) {
            resp.sendRedirect("login");
            return;
        }

        // Update OrderDTO with form data
        orderDTO.setOrderId(getNextOrderId());
        orderDTO.setDate(Date.valueOf(LocalDate.now()));
        orderDTO.setAddress(req.getParameter("address"));
        orderDTO.setCity(req.getParameter("city"));
        orderDTO.setState(req.getParameter("state"));
        orderDTO.setZipCode(req.getParameter("zipCode"));
        orderDTO.setStatus("Pending");
        orderDTO.setPaymentMethod(req.getParameter("paymentMethod"));

        try (Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);

            try {
                // Insert into orders table
                String orderSql = "INSERT INTO orders (orderId, date, userId, address, city, state, zipCode, status, subTotal, shipingCost, paymentMethod) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement orderStmt = connection.prepareStatement(orderSql);
                orderStmt.setString(1, orderDTO.getOrderId());
                orderStmt.setDate(2, orderDTO.getDate());
                orderStmt.setInt(3, orderDTO.getUserId());
                orderStmt.setString(4, orderDTO.getAddress());
                orderStmt.setString(5, orderDTO.getCity());
                orderStmt.setString(6, orderDTO.getState());
                orderStmt.setString(7, orderDTO.getZipCode());
                orderStmt.setString(8, orderDTO.getStatus());
                orderStmt.setBigDecimal(9, orderDTO.getSubTotal());
                orderStmt.setBigDecimal(10, orderDTO.getShippingCost());
                orderStmt.setString(11, orderDTO.getPaymentMethod());

                orderStmt.executeUpdate();

                // Insert order details and update product quantities
                String detailsSql = "INSERT INTO order_details (orderId, itemCode, quantity) VALUES (?, ?, ?)";
                PreparedStatement detailsStmt = connection.prepareStatement(detailsSql);

                String updateProductSql = "UPDATE products SET qtyOnHand = qtyOnHand - ? WHERE itemCode = ?";
                PreparedStatement updateProductStmt = connection.prepareStatement(updateProductSql);

                for (OrderDetailDTO detail : orderDTO.getOrderDetails()) {
                    // Insert order detail
                    detailsStmt.setString(1, orderDTO.getOrderId());
                    detailsStmt.setInt(2, detail.getItemCode());
                    detailsStmt.setInt(3, detail.getQuantity());
                    detailsStmt.executeUpdate();

                    // Update product quantity
                    updateProductStmt.setInt(1, detail.getQuantity());
                    updateProductStmt.setInt(2, detail.getItemCode());
                    updateProductStmt.executeUpdate();
                }

                // Clear cart details
                String clearCartDetailsSql = "DELETE FROM cart_details WHERE cartId = ?";
                PreparedStatement clearCartDetailsStmt = connection.prepareStatement(clearCartDetailsSql);
                clearCartDetailsStmt.setInt(1, cartId);
                clearCartDetailsStmt.executeUpdate();

                connection.commit();

                // Clean up session
                session.removeAttribute("orderDTO");
                session.removeAttribute("cartId");

                resp.sendRedirect("customer/cart.jsp?message=Order placed successfully!");

            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
                resp.sendRedirect("checkout?error=Failed to place order");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("checkout?error=Database error");
        }
    }

    private String getNextOrderId() {
        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT orderId FROM orders ORDER BY orderId DESC LIMIT 1";
            PreparedStatement pstm = connection.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();

            if (rs.next()) {
                String lastOrderId = rs.getString("orderId");
                // Extract the numeric part and increment it
                int lastOrderNumber = 0;
                if (lastOrderId != null && lastOrderId.startsWith("ORD-")) {
                    String numericPart = lastOrderId.substring(4); // Extract the part after "ORD-"
                    try {
                        lastOrderNumber = Integer.parseInt(numericPart); // Convert to integer
                    } catch (NumberFormatException e) {
                       e.printStackTrace();
                    }
                }

                // Increment the last order number
                int newOrderNumber = lastOrderNumber + 1;

                // Generate the new order ID with the format "ORD-<new number>"
                String newOrderId = "ORD-" + newOrderNumber;
                return newOrderId;
            } else {
                return "ORD-1";
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}