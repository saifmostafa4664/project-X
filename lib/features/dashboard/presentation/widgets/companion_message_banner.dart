/// Smart Umbrella App - Companion Message Banner Widget
///
/// Displays contextual companion messages like battery status,
/// solar activity, and power saving suggestions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../state/battery_provider.dart';
import '../../../../device/models/umbrella_state.dart';

class CompanionMessageBanner extends ConsumerWidget {
  const CompanionMessageBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(primaryCompanionMessageProvider);

    if (message == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bgColor, iconColor, icon) = _getMessageStyle(message.type, isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child:
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: iconColor.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.warmGray100
                            : AppColors.warmGray800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().shimmer(
            duration: 2000.ms,
            color: iconColor.withValues(alpha: 0.1),
          ),
    );
  }

  (Color, Color, IconData) _getMessageStyle(
    CompanionMessageType type,
    bool isDark,
  ) {
    switch (type) {
      case CompanionMessageType.success:
        return (
          AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
          AppColors.success,
          Icons.check_circle_rounded,
        );
      case CompanionMessageType.warning:
        return (
          AppColors.warning.withValues(alpha: isDark ? 0.15 : 0.1),
          AppColors.warning,
          Icons.warning_rounded,
        );
      case CompanionMessageType.error:
        return (
          AppColors.error.withValues(alpha: isDark ? 0.15 : 0.1),
          AppColors.error,
          Icons.error_rounded,
        );
      case CompanionMessageType.tip:
        return (
          AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
          AppColors.primary,
          Icons.lightbulb_rounded,
        );
      case CompanionMessageType.info:
        return (
          AppColors.solar.withValues(alpha: isDark ? 0.15 : 0.1),
          AppColors.solar,
          Icons.wb_sunny_rounded,
        );
    }
  }
}
