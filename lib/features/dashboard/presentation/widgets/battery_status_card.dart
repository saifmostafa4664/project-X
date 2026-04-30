/// Smart Umbrella App - Premium Battery Status Card Widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
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

    final pct = battery.percentage;
    final isCharging = battery.chargingStatus == ChargingStatus.charging;
    final isLow = battery.isLow;
    final isSolar = battery.isSolarActive;

    final trackColor = isLow
        ? AppColors.error
        : isCharging
            ? AppColors.success
            : AppColors.primary;

    return GestureDetector(
      onTap: () => context.push(RoutePaths.battery),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? AppColors.slate700 : AppColors.slate200,
          ),
          boxShadow: [
            BoxShadow(
              color: trackColor.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Arc progress indicator
              SizedBox(
                width: 68,
                height: 68,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(68, 68),
                      painter: _ArcProgressPainter(
                        progress: pct / 100,
                        color: trackColor,
                        trackColor: isDark
                            ? AppColors.slate700
                            : AppColors.slate200,
                      ),
                    ),
                    Icon(
                      isCharging ? Icons.bolt_rounded : Icons.battery_std_rounded,
                      color: trackColor,
                      size: 22,
                    )
                        .animate(onPlay: (c) => isCharging ? c.repeat() : null)
                        .shimmer(
                          delay: 500.ms,
                          duration: 1200.ms,
                          color: trackColor.withValues(alpha: 0.5),
                        ),
                  ],
                ),
              ),

              const SizedBox(width: 18),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$pct%',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: trackColor,
                          ),
                        ),
                        if (isCharging) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Text(
                              'Charging',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _statusText(battery),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                    if (isSolar) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.amber.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wb_sunny_rounded,
                                color: AppColors.amber, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              '${battery.solarPowerWatts.toStringAsFixed(1)}W Solar',
                              style: const TextStyle(
                                color: AppColors.amberDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.slate500 : AppColors.slate400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(BatteryState battery) {
    if (battery.chargingStatus == ChargingStatus.full) {
      return 'Fully charged';
    } else if (battery.chargingStatus == ChargingStatus.charging) {
      if (battery.minutesToFull != null) {
        final h = battery.minutesToFull! ~/ 60;
        final m = battery.minutesToFull! % 60;
        return h > 0 ? '~$h hr $m min to full' : '~$m min to full';
      }
      return 'Charging from solar';
    } else if (battery.isLow) {
      return 'Low battery — connect to charge';
    } else if (battery.minutesRemaining != null) {
      final h = battery.minutesRemaining! ~/ 60;
      final m = battery.minutesRemaining! % 60;
      return h > 0 ? '~$h hr $m min remaining' : '~$m min remaining';
    }
    return 'Tap for details';
  }
}

class _ArcProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _ArcProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 5;
    const startAngle = -math.pi * 0.75;
    const sweepFull = math.pi * 1.5;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepFull,
        false,
        trackPaint);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepFull * progress,
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(_ArcProgressPainter old) =>
      old.progress != progress || old.color != color;
}
