package com.sayak.repository;

import com.sayak.entity.OtpVerification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface OtpVerificationRepository extends JpaRepository<OtpVerification, Long> {

    @Query("SELECT o FROM OtpVerification o WHERE o.phoneNumber = :phone AND o.purpose = :purpose AND o.isVerified = false ORDER BY o.createdAt DESC LIMIT 1")
    Optional<OtpVerification> findLatestActiveOtp(@Param("phone") String phone, @Param("purpose") String purpose);

    Optional<OtpVerification> findTopByPhoneNumberAndPurposeAndIsVerifiedFalseOrderByCreatedAtDesc(String phoneNumber, String purpose);

    long deleteByExpiresAtBefore(LocalDateTime now);
}
