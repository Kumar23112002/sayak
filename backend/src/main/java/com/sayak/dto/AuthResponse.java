package com.sayak.dto;

public class AuthResponse {

    private boolean success;
    private String message;
    private String token;
    private String tokenType = "Bearer";
    private UserDto user;
    private boolean isNewUser;

    public AuthResponse() {
    }

    public AuthResponse(boolean success, String message, String token, UserDto user, boolean isNewUser) {
        this.success = success;
        this.message = message;
        this.token = token;
        this.user = user;
        this.isNewUser = isNewUser;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }

    public UserDto getUser() {
        return user;
    }

    public void setUser(UserDto user) {
        this.user = user;
    }

    public boolean isNewUser() {
        return isNewUser;
    }

    public void setNewUser(boolean newUser) {
        isNewUser = newUser;
    }
}
