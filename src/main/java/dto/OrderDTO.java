package dto;

import lombok.*;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString

public class OrderDTO {
    private String orderId;
    private Date date;
    private int userId;
    private String address;
    private String city;
    private String state;
    private String zipCode;
    private String status;
    private BigDecimal subTotal;
    private BigDecimal shippingCost;
    private String paymentMethod;
    private String customerName;
    private byte[] customerImage;
    private List<OrderDetailDTO> orderDetails;
}
