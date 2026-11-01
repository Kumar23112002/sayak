import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/grocery_header.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final cleanPhone = _phoneController.text.trim().replaceAll(RegExp(r'\s+'), '');
      final result = await BackendAuthService.sendOtp(cleanPhone);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showOtpBottomSheet(cleanPhone, result['devOtp'] as String?);
      } else {
        final msg = result['message'] ?? 'Failed to send OTP. Please try again.';
        final bool isAccountNotFound = msg.toLowerCase().contains('create an account') ||
            msg.toLowerCase().contains('no account');

        if (isAccountNotFound) {
          _showAccountNotFoundSheet(cleanPhone);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 4),
              content: Text(
                msg,
                style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }
      }
    }
  }

  void _showAccountNotFoundSheet(String phone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),

            // Glowing Icon Badge
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.brandPrimary.withValues(alpha: 0.35), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: AppColors.brandPrimary,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),

            // Header Title
            const Text(
              'New to Sayak Groceries?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),

            // Phone pill container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySurface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone_iphone_rounded, size: 16, color: AppColors.brandPrimary),
                  const SizedBox(width: 6),
                  Text(
                    '+91 $phone',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Friendly description
            const Text(
              'We couldn\'t find an existing account with this mobile number. Create your account in just 30 seconds to start shopping fresh daily groceries!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),

            // Perks Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _PerkItem(icon: Icons.bolt_rounded, label: 'Fast Delivery'),
                  _PerkItem(icon: Icons.eco_rounded, label: '100% Fresh'),
                  _PerkItem(icon: Icons.discount_rounded, label: 'Best Prices'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Primary Button: Create Account Now
            CustomPrimaryButton(
              text: 'Create Sayak Account',
              icon: Icons.arrow_forward_rounded,
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(initialPhone: phone),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Secondary: Re-check number
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Enter Different Number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOtpBottomSheet(String phone, String? devOtp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _OtpVerificationSheet(
        phoneNumber: phone,
        initialDevOtp: devOtp,
        onSuccess: (userData) {
          Navigator.pop(ctx);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: userData),
            ),
            (route) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Decorative Subtle Ambient Shapes
          Positioned(
            top: -size.width * 0.25,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.75,
              height: size.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.3,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySurface,
              ),
            ),
          ),

          // Main Scrollable Body
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sayak Logo Header
                        const GroceryHeader(
                          title: 'Sayak',
                          subtitle: 'Daily Needs • Fresh Groceries • Fast Delivery',
                          useImageLogo: true,
                          showBadge: false,
                        ),
                        const SizedBox(height: 18),

                        // Form Card Container
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.border, width: 1.2),
                            boxShadow: AppColors.cardElevation,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: const [
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Enter your mobile number to sign in',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Mobile Number (India +91 Only)
                              CustomTextField(
                                controller: _phoneController,
                                label: 'Mobile Number',
                                hintText: 'Enter 10-digit mobile number',
                                prefixIcon: Icons.phone_android_rounded,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onFieldSubmitted: (_) => _handleLogin(),
                                prefixWidget: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.phone_android_rounded,
                                        color: AppColors.brandPrimary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '+91',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '|',
                                        style: TextStyle(
                                          color: AppColors.border,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  final cleanVal = val.trim().replaceAll(RegExp(r'\s+'), '');
                                  if (cleanVal.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(cleanVal)) {
                                    return 'Please enter a valid 10-digit Indian mobile number';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              // Polished Primary Sign In Button
                              CustomPrimaryButton(
                                text: 'Sign In to Shop',
                                icon: Icons.arrow_forward_rounded,
                                isLoading: _isLoading,
                                onPressed: _handleLogin,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Secondary Action: Guest Mode Button
                        CustomOutlineButton(
                          text: 'Explore Store as Guest',
                          icon: Icons.storefront_rounded,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(
                                  user: {'fullName': 'Guest User', 'phone': ''},
                                ),
                              ),
                              (route) => false,
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Switch to Register Screen
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create an Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.brandPrimary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.brandPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpVerificationSheet extends StatefulWidget {
  final String phoneNumber;
  final String? initialDevOtp;
  final Function(Map<String, dynamic>?) onSuccess;

  const _OtpVerificationSheet({
    required this.phoneNumber,
    this.initialDevOtp,
    required this.onSuccess,
  });

  @override
  State<_OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<_OtpVerificationSheet> {
  final _otpController = TextEditingController();
  int _secondsLeft = 30;
  Timer? _timer;
  bool _isVerifying = false;
  String? _errorMessage;
  String? _currentDevOtp;

  @override
  void initState() {
    super.initState();
    _currentDevOtp = widget.initialDevOtp;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        if (mounted) setState(() => _secondsLeft--);
      } else {
        t.cancel();
        if (mounted) setState(() => _secondsLeft = 0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _resendOtp() async {
    setState(() {
      _errorMessage = null;
    });
    final res = await BackendAuthService.sendOtp(widget.phoneNumber);
    if (!mounted) return;
    if (res['success'] == true) {
      setState(() {
        _currentDevOtp = res['devOtp'] as String?;
      });
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A fresh real-time OTP has been sent!'),
          backgroundColor: AppColors.brandPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _errorMessage = res['message'] ?? 'Failed to resend OTP';
      });
    }
  }

  void _handleVerify() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Please enter a 6-digit OTP code');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final res = await BackendAuthService.verifyOtp(widget.phoneNumber, code);

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (res['success'] == true) {
      widget.onSuccess(res['user'] as Map<String, dynamic>?);
    } else {
      setState(() {
        _errorMessage = res['message'] ?? 'Invalid OTP code. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Icon & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.sms_rounded, color: AppColors.brandPrimary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verify Mobile Number',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'OTP sent to +91 ${widget.phoneNumber}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Dev OTP Hint Banner (if available)
            if (_currentDevOtp != null) ...[
              GestureDetector(
                onTap: () {
                  _otpController.text = _currentDevOtp!;
                  setState(() => _errorMessage = null);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.brandPrimary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: AppColors.brandPrimary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Real-Time OTP: $_currentDevOtp  (Tap to fill)',
                          style: const TextStyle(
                            color: AppColors.brandPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // OTP Input Field
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••••',
                hintStyle: TextStyle(
                  letterSpacing: 10,
                  color: AppColors.textMuted,
                  fontSize: 24,
                ),
                filled: true,
                fillColor: AppColors.primarySurface.withValues(alpha: 0.4),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2),
                ),
              ),
            ),

            // Error display if any
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Resend Timer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_secondsLeft > 0)
                  Text(
                    'Resend code in $_secondsLeft s',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _resendOtp,
                    child: const Text(
                      'Resend New OTP',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Verify & Sign In Button
            CustomPrimaryButton(
              text: 'Verify & Sign In',
              icon: Icons.check_circle_rounded,
              isLoading: _isVerifying,
              onPressed: _handleVerify,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _PerkItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PerkItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.brandPrimary, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

