library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/feature_screen_header.dart';
import '../../../core/widgets/themed_surface_container.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/utils/gradient_helpers.dart';
import '../../../state/battery_provider.dart';
import '../../../device/models/umbrella_state.dart';

class BatteryScreen extends ConsumerWidget {
  const BatteryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(batteryStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isCharging = battery.chargingStatus == ChargingStatus.charging;
    final isFull = battery.chargingStatus == ChargingStatus.full;

    Color batteryColor;
    if (battery.isCritical) {
      batteryColor = AppColors.error;
    } else if (battery.isLow) {
      batteryColor = AppColors.warning;
    } else if (isCharging || isFull) {
      batteryColor = AppColors.success;
    } else {
      batteryColor = AppColors.primary;
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _BatteryHeader(
              isDark: isDark,
              batteryColor: batteryColor,
              percentage: battery.percentage,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [batteryColor, batteryColor.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: batteryColor.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: battery.percentage / 100,
                          strokeWidth: 12,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${battery.percentage}%',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (isCharging)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bolt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  'Charging',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    _getStatusText(battery),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 24),

            Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: battery.isSolarActive
                        ? AppColors.solarGradient
                        : inactiveGradient(isDark),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconBadge(
                        icon: Icons.solar_power_rounded,
                        color: battery.isSolarActive
                            ? Colors.white
                            : AppColors.warmGray500,
                        size: 64,
                        iconSize: 32,
                        borderRadius: 16,
                        backgroundAlpha: 0.2,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solar Panel',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: battery.isSolarActive
                                        ? Colors.white
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              battery.isSolarActive
                                  ? '${battery.solarPowerWatts.toStringAsFixed(1)}W output'
                                  : 'Not receiving sunlight',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: battery.isSolarActive
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : (isDark
                                              ? AppColors.warmGray400
                                              : AppColors.warmGray500),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (battery.hasStrongSunlight)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('☀️ Strong'),
                        ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 100.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.bolt_rounded,
                    label: 'Status',
                    value: _getChargingStatusText(battery.chargingStatus),
                    color: batteryColor,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.access_time_rounded,
                    label: isCharging ? 'Time to Full' : 'Remaining',
                    value: _getTimeText(battery),
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

            const SizedBox(height: 24),

            ThemedSurfaceContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates_rounded,
                        color: AppColors.solar,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Power Saving Tips',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TipItem(
                    text: 'Turn off lights when not needed',
                    isDark: isDark,
                  ),
                  _TipItem(
                    text: 'Lower volume or pause music to save power',
                    isDark: isDark,
                  ),
                  _TipItem(
                    text: 'Position umbrella for maximum sun exposure',
                    isDark: isDark,
                  ),
                  _TipItem(
                    text: 'Close umbrella during peak sun for faster charging',
                    isDark: isDark,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

            const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BatteryState battery) {
    if (battery.chargingStatus == ChargingStatus.full) {
      return 'Fully charged and ready to go!';
    } else if (battery.isCritical) {
      return 'Battery critically low!\nCharge immediately.';
    } else if (battery.isLow) {
      return 'Battery running low.\nConsider charging soon.';
    } else if (battery.chargingStatus == ChargingStatus.charging) {
      return 'Charging from solar power';
    }
    return 'Battery in good condition';
  }

  String _getChargingStatusText(ChargingStatus status) {
    switch (status) {
      case ChargingStatus.charging:
        return 'Charging';
      case ChargingStatus.discharging:
        return 'In Use';
      case ChargingStatus.full:
        return 'Full';
      case ChargingStatus.notConnected:
        return 'N/A';
    }
  }

  String _getTimeText(BatteryState battery) {
    if (battery.chargingStatus == ChargingStatus.full) {
      return '—';
    }

    final minutes = battery.chargingStatus == ChargingStatus.charging
        ? battery.minutesToFull
        : battery.minutesRemaining;

    if (minutes == null) return '—';

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  final bool isDark;

  const _TipItem({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _BatteryHeader extends StatelessWidget {
  final bool isDark;
  final Color batteryColor;
  final int percentage;
  const _BatteryHeader({
    required this.isDark,
    required this.batteryColor,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return FeatureScreenHeader(
      icon: Icons.battery_charging_full_rounded,
      title: 'Battery & Solar',
      subtitle: Text(
        '$percentage% Charged',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: batteryColor,
        ),
      ),
      darkGradientColors: const [Color(0xFF0F1A10), Color(0xFF0A1210)],
      lightGradientColors: const [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
      iconGradient: LinearGradient(
        colors: [batteryColor, batteryColor.withValues(alpha: 0.7)],
      ),
      iconShadowColor: batteryColor,
    );
  }
}
