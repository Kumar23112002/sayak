package com.sayak.dto;

import com.sayak.entity.User;

public class UserDto {

    private Long id;
    private String phoneNumber;
    private String fullName;
    private String email;
    private String role;

    public UserDto() {
    }

    public UserDto(Long id, String phoneNumber, String fullName, String email, String role) {
        this.id = id;
        this.phoneNumber = phoneNumber;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
    }

    public static UserDto fromEntity(User user) {
        if (user == null) return null;
        return new UserDto(
                user.getId(),
                user.getPhoneNumber(),
                user.getFullName(),
                user.getEmail(),
                user.getRole()
        );
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
