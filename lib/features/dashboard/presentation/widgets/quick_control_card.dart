/// Smart Umbrella App - Quick Control Card Widget
///
/// Reusable card for quick access to lighting and sound controls
/// with toggle functionality.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isActive;
  final bool isEnabled;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const QuickControlCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isActive,
    required this.isEnabled,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? iconColor.withValues(alpha: 0.3)
              : (isDark ? AppColors.warmGray700 : AppColors.warmGray200),
          width: 1.5,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon and Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon Container
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isActive
                            ? iconColor.withValues(alpha: 0.15)
                            : (isDark
                                  ? AppColors.warmGray800
                                  : AppColors.warmGray100),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: iconColor, size: 26),
                    ),
                    // Toggle Switch
                    GestureDetector(
                      onTap: isEnabled ? onToggle : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 52,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isActive
                              ? iconColor
                              : (isDark
                                    ? AppColors.warmGray700
                                    : AppColors.warmGray300),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          alignment: isActive
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // Subtitle
                Text(
                  isEnabled ? subtitle : 'Offline',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
