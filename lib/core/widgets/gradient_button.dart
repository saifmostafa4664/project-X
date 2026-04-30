/// Gradient primary button with shimmer animation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double borderRadius;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.gradient = AppColors.violetGradient,
    this.borderRadius = 18,
    this.width,
    this.padding,
    this.textStyle,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: widget.width,
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? widget.gradient
                : const LinearGradient(
                    colors: [Color(0xFFCBD5E1), Color(0xFFCBD5E1)],
                  ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
              ),
            ],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .shimmer(
              delay: 2000.ms,
              duration: 1200.ms,
              color: Colors.white.withValues(alpha: 0.15),
            ),
      ),
    );
  }
}
