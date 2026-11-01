package com.sayak.service;

import com.sayak.entity.OtpVerification;
import com.sayak.repository.OtpVerificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class OtpService {

    private static final Logger log = LoggerFactory.getLogger(OtpService.class);

    private final OtpVerificationRepository otpRepository;
    private final SmsService smsService;
    private final SecureRandom secureRandom = new SecureRandom();

    @Value("${sayak.otp.expiration-seconds:300}")
    private int expirationSeconds;

    @Value("${sayak.otp.length:6}")
    private int otpLength;

    @Value("${sayak.otp.max-attempts:5}")
    private int maxAttempts;

    @Value("${sayak.otp.dev-mode:true}")
    private boolean devMode;

    public OtpService(OtpVerificationRepository otpRepository, SmsService smsService) {
        this.otpRepository = otpRepository;
        this.smsService = smsService;
    }

    /**
     * Generates a real-time OTP, saves it in Supabase DB, and triggers SMS delivery.
     */
    @Transactional
    public String generateAndSendOtp(String phoneNumber, String purpose) {
        // Generate cryptographic numeric OTP (e.g. 6 digits)
        String otp = generateNumericOtp(otpLength);

        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(expirationSeconds);

        OtpVerification otpEntity = new OtpVerification(phoneNumber, otp, purpose, expiresAt);
        otpRepository.save(otpEntity);

        int validMinutes = Math.max(1, expirationSeconds / 60);

        // Real-time SMS dispatch
        boolean sent = smsService.sendOtp(phoneNumber, otp, validMinutes);
        if (!sent) {
            log.warn("SMS service failed to deliver OTP, but saved in DB.");
        }

        return otp;
    }

    /**
     * Verifies the submitted OTP against the latest active record in the database.
     */
    @Transactional
    public boolean verifyOtp(String phoneNumber, String otp, String purpose) {
        Optional<OtpVerification> optOtp = otpRepository.findTopByPhoneNumberAndPurposeAndIsVerifiedFalseOrderByCreatedAtDesc(phoneNumber, purpose);

        if (optOtp.isEmpty()) {
            log.warn("No active OTP found for phone {} with purpose {}", phoneNumber, purpose);
            return false;
        }

        OtpVerification verification = optOtp.get();

        // Check if expired
        if (verification.isExpired()) {
            log.warn("OTP for phone {} expired at {}", phoneNumber, verification.getExpiresAt());
            return false;
        }

        // Check attempts limit
        if (verification.getAttempts() >= maxAttempts) {
            log.warn("Max OTP verification attempts exceeded for phone {}", phoneNumber);
            return false;
        }

        // Increment attempts
        verification.setAttempts(verification.getAttempts() + 1);

        // Check OTP match
        if (verification.getOtpCode().equals(otp.trim())) {
            verification.setIsVerified(true);
            otpRepository.save(verification);
            log.info("OTP verified successfully for phone {}", phoneNumber);
            return true;
        } else {
            otpRepository.save(verification);
            log.warn("Invalid OTP entered for phone {}. Entered: {}, Expected: {}", phoneNumber, otp, verification.getOtpCode());
            return false;
        }
    }

    private String generateNumericOtp(int length) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(secureRandom.nextInt(10));
        }
        return sb.toString();
    }

    public boolean isDevMode() {
        return devMode;
    }

    public int getExpirationSeconds() {
        return expirationSeconds;
    }
}
