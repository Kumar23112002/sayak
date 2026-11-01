package com.sayak.service;

import com.sayak.dto.*;
import com.sayak.entity.User;
import com.sayak.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final UserRepository userRepository;
    private final OtpService otpService;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, OtpService otpService, JwtService jwtService) {
        this.userRepository = userRepository;
        this.otpService = otpService;
        this.jwtService = jwtService;
    }

    /**
     * Sends Real-time OTP to the specified mobile number.
     * Every time a user logs out and wants to log in again, entering their mobile number triggers this.
     */
    @Transactional
    public ApiResponse sendOtp(SendOtpRequest request) {
        String phone = sanitizePhoneNumber(request.getPhone());
        String purpose = (request.getPurpose() != null && !request.getPurpose().isBlank())
                ? request.getPurpose().toUpperCase()
                : "LOGIN";

        Optional<User> existingUser = userRepository.findByPhoneNumber(phone);
        boolean isRegistered = existingUser.isPresent();

        log.info("Requesting OTP for phone: {}, Purpose: {}, IsRegistered: {}", phone, purpose, isRegistered);

        // If trying to LOGIN and account does NOT exist in DB, instruct them to create an account
        if ("LOGIN".equalsIgnoreCase(purpose) && !isRegistered) {
            Map<String, Object> errorData = new HashMap<>();
            errorData.put("phone", phone);
            errorData.put("isRegistered", false);
            return new ApiResponse(false, "No account found with this mobile number. Please create an account first!", errorData);
        }

        // Generate and dispatch real-time OTP
        String otpCode = otpService.generateAndSendOtp(phone, purpose);

        Map<String, Object> data = new HashMap<>();
        data.put("phone", phone);
        data.put("expiresInSeconds", otpService.getExpirationSeconds());
        data.put("isRegistered", isRegistered);

        // In dev mode, return the OTP in the API response for instant testing
        if (otpService.isDevMode()) {
            data.put("devOtp", otpCode);
        }

        String msg = "Real-time OTP sent successfully to +91 " + phone;
        return ApiResponse.ok(msg, data);
    }

    /**
     * Verifies the OTP and logs the user in, returning a secure JWT token.
     */
    @Transactional
    public AuthResponse verifyOtpAndLogin(VerifyOtpRequest request) {
        String phone = sanitizePhoneNumber(request.getPhone());
        String otp = request.getOtp().trim();
        String purpose = (request.getPurpose() != null && !request.getPurpose().isBlank())
                ? request.getPurpose().toUpperCase()
                : "LOGIN";

        // Check if user exists
        Optional<User> optUser = userRepository.findByPhoneNumber(phone);
        if (optUser.isEmpty()) {
            return new AuthResponse(false, "Account not found with this mobile number. Please create an account first.", null, null, false);
        }

        boolean isValid = otpService.verifyOtp(phone, otp, purpose);

        if (!isValid) {
            return new AuthResponse(false, "Invalid or expired OTP. Please enter the correct 6-digit code or request a new OTP.", null, null, false);
        }

        User user = optUser.get();
        log.info("User logged in successfully: {}", phone);

        // Generate JWT token for session
        String token = jwtService.generateToken(user.getPhoneNumber(), user.getId(), user.getRole());

        return new AuthResponse(
                true,
                "Sign In successful! Welcome to Sayak Groceries.",
                token,
                UserDto.fromEntity(user),
                false
        );
    }

    /**
     * Handles User Registration from the Register Screen.
     */
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String phone = sanitizePhoneNumber(request.getPhone());

        Optional<User> existingUser = userRepository.findByPhoneNumber(phone);
        User user;

        if (existingUser.isPresent()) {
            user = existingUser.get();
            user.setFullName(request.getFullName());
            if (request.getEmail() != null && !request.getEmail().isBlank()) {
                user.setEmail(request.getEmail().trim());
            }
            user = userRepository.save(user);
            log.info("Updated existing user profile: {}", phone);
        } else {
            user = new User(phone, request.getFullName().trim(), request.getEmail() != null ? request.getEmail().trim() : null);
            user = userRepository.save(user);
            log.info("Created new user from Register screen: {}", phone);
        }

        String token = jwtService.generateToken(user.getPhoneNumber(), user.getId(), user.getRole());

        return new AuthResponse(
                true,
                "Account created successfully! Welcome to Sayak Groceries.",
                token,
                UserDto.fromEntity(user),
                false
        );
    }

    /**
     * Gets the profile of the currently authenticated user.
     */
    @Transactional(readOnly = true)
    public ApiResponse getCurrentUserProfile(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber)
                .map(user -> ApiResponse.ok("User profile retrieved", UserDto.fromEntity(user)))
                .orElseGet(() -> ApiResponse.error("User not found"));
    }

    private String sanitizePhoneNumber(String phone) {
        if (phone == null) return "";
        String cleaned = phone.trim().replaceAll("\\s+", "");
        if (cleaned.startsWith("+91")) {
            cleaned = cleaned.substring(3);
        } else if (cleaned.startsWith("91") && cleaned.length() == 12) {
            cleaned = cleaned.substring(2);
        }
        return cleaned;
    }
}
