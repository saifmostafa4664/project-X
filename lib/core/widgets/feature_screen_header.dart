library;

import 'package:flutter/material.dart';

class FeatureScreenHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget subtitle;
  final List<Color> darkGradientColors;
  final List<Color> lightGradientColors;
  final Gradient iconGradient;
  final Color iconShadowColor;

  const FeatureScreenHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.darkGradientColors,
    required this.lightGradientColors,
    required this.iconGradient,
    required this.iconShadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? darkGradientColors : lightGradientColors,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: iconGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: iconShadowColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : darkGradientColors.first,
                  ),
                ),
                subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
