package dto;

import lombok.*;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString

public class UserDTO {
    private int userId;
    private String username;
    private String email;
    private String password;
    private String role;
    private String fullName;
    private String address;
    private String phoneNumber;
    private String status;
    private Timestamp date;
    private byte[] image; // To hold the LONGBLOB
}
