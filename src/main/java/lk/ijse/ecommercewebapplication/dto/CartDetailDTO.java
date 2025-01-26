package lk.ijse.ecommercewebapplication.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString

public class CartDetailDTO {
    private int cartId;
    private int itemCode;
    private int quantity;
    private String productName;
    private double unitPrice;
    private String description;
    private byte[] image;
}
