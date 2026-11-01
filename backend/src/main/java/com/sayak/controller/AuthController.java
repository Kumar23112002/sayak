package com.sayak.controller;

import com.sayak.dto.*;
import com.sayak.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<ApiResponse> health() {
        return ResponseEntity.ok(ApiResponse.ok("Sayak Backend & Database Service is running healthy! 🛒"));
    }

    /**
     * 1. Send Real-time OTP to Mobile Number
     * Used every time user clicks Sign In or requests OTP.
     */
    @PostMapping("/send-otp")
    public ResponseEntity<ApiResponse> sendOtp(@Valid @RequestBody SendOtpRequest request) {
        ApiResponse response = authService.sendOtp(request);
        return ResponseEntity.ok(response);
    }

    /**
     * 2. Verify OTP & Log In
     * Used when user enters the 6-digit real-time OTP to sign in.
     */
    @PostMapping("/verify-otp")
    public ResponseEntity<AuthResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        AuthResponse response = authService.verifyOtpAndLogin(request);
        if (!response.isSuccess()) {
            return ResponseEntity.badRequest().body(response);
        }
        return ResponseEntity.ok(response);
    }

    /**
     * 3. Register New User
     * Used on the Register screen.
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(response);
    }

    /**
     * 4. User Logout
     * Clears user session.
     */
    @PostMapping("/logout")
    public ResponseEntity<ApiResponse> logout() {
        return ResponseEntity.ok(ApiResponse.ok("Logged out successfully! Come back soon to Sayak."));
    }

    /**
     * 5. Get Current User Profile (Protected - Requires JWT)
     */
    @GetMapping("/me")
    public ResponseEntity<ApiResponse> getMe(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Unauthorized"));
        }
        String phoneNumber = authentication.getName();
        return ResponseEntity.ok(authService.getCurrentUserProfile(phoneNumber));
    }
}
