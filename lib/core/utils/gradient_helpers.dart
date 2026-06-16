library;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

LinearGradient inactiveGradient(bool isDark) {
  return LinearGradient(
    colors: [
      isDark ? AppColors.warmGray800 : AppColors.warmGray200,
      isDark ? AppColors.warmGray700 : AppColors.warmGray300,
    ],
  );
}
