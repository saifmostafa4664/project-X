/// Smart Umbrella App - Premium Quick Control Card Widget
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickControlCard extends StatefulWidget {
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
  State<QuickControlCard> createState() => _QuickControlCardState();
}

class _QuickControlCardState extends State<QuickControlCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = widget.iconColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isDark
                ? (widget.isActive
                    ? color.withValues(alpha: 0.12)
                    : AppColors.darkSurface)
                : (widget.isActive
                    ? color.withValues(alpha: 0.07)
                    : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isActive
                  ? color.withValues(alpha: isDark ? 0.3 : 0.2)
                  : (isDark ? AppColors.slate700 : AppColors.slate200),
              width: 1.5,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + toggle row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon with animated glow container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? color.withValues(alpha: 0.18)
                            : (isDark
                                ? AppColors.slate800
                                : AppColors.slate100),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: widget.isActive
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                )
                              ]
                            : [],
                      ),
                      child: Icon(widget.icon, color: color, size: 26),
                    ),
                    // Custom animated toggle
                    _PremiumToggle(
                      isActive: widget.isActive,
                      activeColor: color,
                      onTap: widget.isEnabled ? widget.onToggle : null,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.isEnabled ? widget.subtitle : 'Offline',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
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

class _PremiumToggle extends StatefulWidget {
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;

  const _PremiumToggle({
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<_PremiumToggle> createState() => _PremiumToggleState();
}

class _PremiumToggleState extends State<_PremiumToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(_PremiumToggle old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value;
          final bg = Color.lerp(
            isDark ? AppColors.slate700 : AppColors.slate300,
            widget.activeColor,
            t,
          )!;

          return Container(
            width: 50,
            height: 28,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: widget.activeColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Align(
              alignment: Alignment.lerp(
                Alignment.centerLeft,
                Alignment.centerRight,
                t,
              )!,
              child: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
