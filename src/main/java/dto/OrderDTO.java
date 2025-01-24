package dto;

import lombok.*;

import java.math.BigDecimal;
import java.sql.Date;

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
}
