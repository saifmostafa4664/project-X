library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedStatusDot extends StatelessWidget {
  final Color color;
  final double size;
  final bool animate;

  const AnimatedStatusDot({
    super.key,
    required this.color,
    this.size = 10,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: size),
        ],
      ),
    );

    if (!animate) return dot;

    return dot
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1.15, 1.15),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }
}
