/// Smart Umbrella App - Battery Status Card Widget
///
/// Displays battery percentage, charging status, and solar activity
/// with visual indicators.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../state/battery_provider.dart';
import '../../../../device/models/umbrella_state.dart';

class BatteryStatusCard extends ConsumerWidget {
  const BatteryStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(batteryStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final percentage = battery.percentage;
    final isCharging = battery.chargingStatus == ChargingStatus.charging;
    final isLow = battery.isLow;
    final isSolarActive = battery.isSolarActive;

    Color progressColor;
    if (isLow) {
      progressColor = AppColors.error;
    } else if (isCharging) {
      progressColor = AppColors.success;
    } else {
      progressColor = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.warmGray700 : AppColors.warmGray200,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(RoutePaths.battery),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Battery Icon with percentage
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 4,
                            valueColor: AlwaysStoppedAnimation(progressColor),
                            backgroundColor: isDark
                                ? AppColors.warmGray700
                                : AppColors.warmGray200,
                          ),
                        ),
                        Icon(
                          isCharging
                              ? Icons.bolt_rounded
                              : Icons.battery_std_rounded,
                          color: progressColor,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Percentage and status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$percentage%',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: progressColor,
                                    ),
                              ),
                              if (isCharging) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Charging',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusText(battery),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.warmGray400
                                      : AppColors.warmGray500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Solar indicator
                    if (isSolarActive)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.solarGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.wb_sunny_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    // Arrow
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColors.warmGray500
                          : AppColors.warmGray400,
                    ),
                  ],
                ),

                // Solar Power Row
                if (isSolarActive) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.solar.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.solar_power_rounded,
                          color: AppColors.solar,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Solar: ${battery.solarPowerWatts.toStringAsFixed(1)}W',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.solarDark,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          battery.hasStrongSunlight
                              ? '☀️ Strong'
                              : '🌤️ Moderate',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(BatteryState battery) {
    if (battery.chargingStatus == ChargingStatus.full) {
      return 'Fully charged';
    } else if (battery.chargingStatus == ChargingStatus.charging) {
      if (battery.minutesToFull != null) {
        final hours = battery.minutesToFull! ~/ 60;
        final mins = battery.minutesToFull! % 60;
        if (hours > 0) {
          return '~$hours hr $mins min to full';
        }
        return '~$mins min to full';
      }
      return 'Charging from solar';
    } else if (battery.isLow) {
      return 'Low battery - connect to charge';
    } else if (battery.minutesRemaining != null) {
      final hours = battery.minutesRemaining! ~/ 60;
      final mins = battery.minutesRemaining! % 60;
      if (hours > 0) {
        return '~$hours hr $mins min remaining';
      }
      return '~$mins min remaining';
    }
    return 'Tap for details';
  }
}
