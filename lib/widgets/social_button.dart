import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Authentic 4-color Google 'G' Logo Widget
class GoogleLogoWidget extends StatelessWidget {
  final double size;
  const GoogleLogoWidget({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final strokeW = radius * 0.42;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeW / 2);

    // 1. Red Arc (Top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -math.pi * 0.75, math.pi * 0.55, false, paint);

    // 2. Yellow Arc (Left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -math.pi * 1.25, math.pi * 0.55, false, paint);

    // 3. Green Arc (Bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, math.pi * 0.25, math.pi * 0.55, false, paint);

    // 4. Blue Arc & Bar (Right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -math.pi * 0.22, math.pi * 0.50, false, paint);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final barHeight = strokeW;
    final barRect = Rect.fromLTWH(
      center.dx - radius * 0.05,
      center.dy - barHeight / 2,
      radius * 1.05,
      barHeight,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SocialAuthButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide? borderSide;

  const SocialAuthButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
  });

  factory SocialAuthButton.google({required VoidCallback onTap}) {
    return SocialAuthButton(
      label: 'Google',
      icon: const GoogleLogoWidget(size: 20),
      onTap: onTap,
      backgroundColor: AppColors.surface,
      textColor: AppColors.textPrimary,
      borderSide: const BorderSide(color: AppColors.border, width: 1.2),
    );
  }

  factory SocialAuthButton.phone({required VoidCallback onTap}) {
    return SocialAuthButton(
      label: 'Mobile OTP',
      icon: const Icon(
        Icons.phone_android_rounded,
        color: AppColors.brandPrimary,
        size: 20,
      ),
      onTap: onTap,
      backgroundColor: AppColors.primarySurface,
      textColor: AppColors.brandPrimary,
      borderSide: const BorderSide(color: AppColors.primaryBorder, width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: borderSide != null ? Border.fromBorderSide(borderSide!) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
