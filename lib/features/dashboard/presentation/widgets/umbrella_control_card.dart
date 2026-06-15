library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../state/umbrella_provider.dart';
import '../../../../state/device_provider.dart';
import '../../../../state/lighting_provider.dart';
import '../../../../device/models/umbrella_state.dart';
import 'umbrella_3d_viewer.dart';

class UmbrellaControlCard extends ConsumerWidget {
  const UmbrellaControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(umbrellaPositionProvider);
    final isTransitioning = ref.watch(isUmbrellaTransitioningProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final lighting = ref.watch(lightingStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isOpen = position == UmbrellaPosition.open;
    final openProgress = isOpen
        ? 1.0
        : (position == UmbrellaPosition.opening ||
                position == UmbrellaPosition.closing)
            ? 0.5
            : 0.0;
    final statusText = _statusText(position);

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark.withValues(alpha: 0.95),
                  AppColors.tealDark,
                ],
              )
            : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: isTransitioning
                            ? const Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                              )
                            : Icon(
                                isOpen
                                    ? Icons.beach_access_rounded
                                    : Icons.beach_access_outlined,
                                color: Colors.white,
                                size: 32,
                              )
                                .animate(key: ValueKey(isOpen))
                                .scale(
                                  begin: const Offset(0.7, 0.7),
                                  end: const Offset(1.0, 1.0),
                                  duration: 300.ms,
                                  curve: Curves.easeOutBack,
                                ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Umbrella',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              statusText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isConnected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wifi_off_rounded,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 5),
                              Text(
                                'Offline',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Umbrella3DViewer(
                    openProgress: openProgress,
                    lightOn: lighting.isOn,
                    lightColor: lighting.color,
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: isOpen
                          ? 1.0
                          : isTransitioning
                              ? null
                              : 0.0,
                      minHeight: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _ControlButton(
                          label: 'Open',
                          icon: Icons.keyboard_arrow_up_rounded,
                          isActive: isOpen,
                          isEnabled:
                              isConnected && !isTransitioning && !isOpen,
                          onPressed: () =>
                              ref.read(umbrellaControlProvider.notifier).open(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ControlButton(
                          label: 'Close',
                          icon: Icons.keyboard_arrow_down_rounded,
                          isActive:
                              !isOpen && position == UmbrellaPosition.closed,
                          isEnabled:
                              isConnected && !isTransitioning && isOpen,
                          onPressed: () =>
                              ref.read(umbrellaControlProvider.notifier).close(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(UmbrellaPosition position) {
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
}

class _ControlButton extends StatefulWidget {
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
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.isEnabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.isActive
                ? Colors.white.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isActive
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.12),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white
                    .withValues(alpha: widget.isEnabled ? 1.0 : 0.4),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white
                      .withValues(alpha: widget.isEnabled ? 1.0 : 0.4),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
