/// Smart Umbrella App - Umbrella Control Card Widget
///
/// Hero card for umbrella open/close control with animated
/// status visualization.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../state/umbrella_provider.dart';
import '../../../../state/device_provider.dart';
import '../../../../device/models/umbrella_state.dart';

class UmbrellaControlCard extends ConsumerWidget {
  const UmbrellaControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(umbrellaPositionProvider);
    final isTransitioning = ref.watch(isUmbrellaTransitioningProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isOpen = position == UmbrellaPosition.open;
    final statusText = _getStatusText(position);
    final statusIcon = _getStatusIcon(position);

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.deepOcean.withValues(alpha: 0.8),
                  AppColors.deepOceanDark,
                ],
              )
            : AppColors.oceanGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Status Row
                Row(
                  children: [
                    // Animated Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isTransitioning
                          ? const Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Icon(statusIcon, color: Colors.white, size: 32)
                                .animate(
                                  onPlay: (controller) => isOpen
                                      ? controller.forward()
                                      : controller.reverse(),
                                )
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.0, 1.0),
                                  duration: 300.ms,
                                ),
                    ),
                    const SizedBox(width: 16),
                    // Status Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Umbrella',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Connection indicator
                    if (!isConnected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Offline',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Control Buttons
                Row(
                  children: [
                    // Open Button
                    Expanded(
                      child: _ControlButton(
                        label: 'Open',
                        icon: Icons.keyboard_arrow_up_rounded,
                        isActive: isOpen,
                        isEnabled: isConnected && !isTransitioning && !isOpen,
                        onPressed: () {
                          ref.read(umbrellaControlProvider.notifier).open();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Close Button
                    Expanded(
                      child: _ControlButton(
                        label: 'Close',
                        icon: Icons.keyboard_arrow_down_rounded,
                        isActive:
                            !isOpen && position == UmbrellaPosition.closed,
                        isEnabled: isConnected && !isTransitioning && isOpen,
                        onPressed: () {
                          ref.read(umbrellaControlProvider.notifier).close();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(UmbrellaPosition position) {
    switch (position) {
      case UmbrellaPosition.open:
        return 'Open';
      case UmbrellaPosition.closed:
        return 'Closed';
      case UmbrellaPosition.opening:
        return 'Opening...';
      case UmbrellaPosition.closing:
        return 'Closing...';
    }
  }

  IconData _getStatusIcon(UmbrellaPosition position) {
    switch (position) {
      case UmbrellaPosition.open:
        return Icons.beach_access;
      case UmbrellaPosition.closed:
        return Icons.beach_access_outlined;
      case UmbrellaPosition.opening:
      case UmbrellaPosition.closing:
        return Icons.sync;
    }
  }
}

class _ControlButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? Colors.white.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white.withValues(alpha: isEnabled ? 1.0 : 0.5),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(
                      alpha: isEnabled ? 1.0 : 0.5,
                    ),
                    fontWeight: FontWeight.w600,
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
