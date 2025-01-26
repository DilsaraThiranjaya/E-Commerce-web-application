package lk.ijse.ecommercewebapplication.dto;

import lombok.*;

import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString

public class OrderDetailDTO {
    private String orderId;
    private int itemCode;
    private int quantity;
    private String productName;
    private BigDecimal unitPrice;
}