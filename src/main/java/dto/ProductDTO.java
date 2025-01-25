package dto;

import lombok.*;

import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString

public class ProductDTO {
    private int itemCode;
    private String name;
    private BigDecimal unitPrice;
    private String description;
    private int qtyOnHand;
    private byte[] image;
    private int categoryId;
    private String categoryName;
}
