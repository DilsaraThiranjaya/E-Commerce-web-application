package lk.ijse.ecommercewebapplication.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString

public class CategoryDTO {
    private int id;
    private String name;
    private String description;
    private String status;
    private byte[] icon;
}
