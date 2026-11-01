import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GroceryHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBadge;
  final bool useImageLogo;

  const GroceryHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBadge = true,
    this.useImageLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo Image / Emblem Container
        if (useImageLogo)
          Container(
            height: 88,
            constraints: const BoxConstraints(maxWidth: 160),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.surface,
              boxShadow: AppColors.softShadow,
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo.jpeg',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackLogo();
                },
              ),
            ),
          )
        else
          _buildFallbackLogo(),

        const SizedBox(height: 12),

        // Brand Subtitle / Tagline (Clean without emojis)
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),

        if (showBadge) ...[
          const SizedBox(height: 14),
          // Logo-aligned 4 core value chips (Clean icons, no leaf emojis)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChip(
                  icon: Icons.verified_rounded,
                  text: 'Fresh & Quality',
                  bgColor: AppColors.primarySurface,
                  textColor: AppColors.brandPrimary,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  icon: Icons.bolt_rounded,
                  text: 'Fast Delivery',
                  bgColor: AppColors.accentLight,
                  textColor: AppColors.accentOrange,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  icon: Icons.shield_rounded,
                  text: 'Safe & Hygienic',
                  bgColor: AppColors.primarySurface,
                  textColor: AppColors.brandMedium,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  icon: Icons.home_rounded,
                  text: 'Doorstep Delivery',
                  bgColor: AppColors.kraftLight,
                  textColor: AppColors.kraftBag,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: AppColors.logoGlow,
      ),
      child: const Center(
        child: Icon(
          Icons.shopping_basket_rounded,
          color: AppColors.textLight,
          size: 38,
        ),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
