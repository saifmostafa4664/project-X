library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../state/device_provider.dart';
import '../../../state/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSimulation = ref.watch(simulationModeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(label: 'App', isDark: isDark),
          _InfoTile(isDark: isDark)
              .animate()
              .fadeIn(duration: 350.ms)
              .slideX(begin: -0.05, end: 0),

          const SizedBox(height: 24),

          _SectionHeader(label: 'Appearance', isDark: isDark),
          _ThemeSelector(
            themeMode: themeMode,
            isDark: isDark,
            onChanged: (mode) =>
                ref.read(themeModeProvider.notifier).setMode(mode),
          )
              .animate()
              .fadeIn(delay: 60.ms, duration: 350.ms)
              .slideX(begin: -0.05, end: 0),

          const SizedBox(height: 24),

          _SectionHeader(label: 'Connection', isDark: isDark),
          _PremiumTile(
            icon: Icons.developer_mode_rounded,
            iconColor: AppColors.teal,
            title: 'Simulation Mode',
            subtitle: isSimulation
                ? 'Using fake device for testing'
                : 'Connecting to real hardware',
            trailing: Switch(
              value: isSimulation,
              onChanged: (v) =>
                  ref.read(simulationModeProvider.notifier).state = v,
            ),
            isDark: isDark,
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 350.ms)
              .slideX(begin: -0.05, end: 0),
          const SizedBox(height: 10),
          if (kDebugMode)
            _PremiumTile(
              icon: Icons.bug_report_rounded,
              iconColor: AppColors.amber,
              title: 'Debug Panel',
              subtitle: 'Simulate device states',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.slate500 : AppColors.slate400,
              ),
              onTap: () => context.push(RoutePaths.debug),
              isDark: isDark,
            )
                .animate()
                .fadeIn(delay: 130.ms, duration: 350.ms)
                .slideX(begin: -0.05, end: 0),

          const SizedBox(height: 24),

          _SectionHeader(label: 'About', isDark: isDark),
          _PremiumTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            title: 'About Smart Umbrella',
            subtitle: 'Learn more about this app',
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
            onTap: () => _showAbout(context),
            isDark: isDark,
          )
              .animate()
              .fadeIn(delay: 160.ms, duration: 350.ms)
              .slideX(begin: -0.05, end: 0),
          const SizedBox(height: 10),
          _PremiumTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.success,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
            onTap: () {},
            isDark: isDark,
          )
              .animate()
              .fadeIn(delay: 180.ms, duration: 350.ms)
              .slideX(begin: -0.05, end: 0),
          const SizedBox(height: 10),
          _PremiumTile(
            icon: Icons.description_outlined,
            iconColor: AppColors.rose,
            title: 'Terms of Service',
            subtitle: 'Usage terms and conditions',
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
            onTap: () {},
            isDark: isDark,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 350.ms)
              .slideX(begin: -0.05, end: 0),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.violetGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.beach_access_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(AppStrings.appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appTagline,
                style: Theme.of(ctx).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              'Control your intelligent beach umbrella with solar panels, RGB lighting, and built-in sound system.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text('Version 1.0.0',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.slate500 : AppColors.slate400)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionHeader({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              gradient: AppColors.violetGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isDark ? AppColors.slate400 : AppColors.slate500,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final bool isDark;

  const _InfoTile({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.violetGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.beach_access_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final bool isDark;
  final void Function(ThemeMode) onChanged;

  const _ThemeSelector({
    required this.themeMode,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Theme Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _modeLabel(themeMode),
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _ThemeChip(
                  label: 'Light',
                  icon: Icons.light_mode_rounded,
                  selected: themeMode == ThemeMode.light,
                  isDark: isDark,
                  onTap: () => onChanged(ThemeMode.light),
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'System',
                  icon: Icons.contrast_rounded,
                  selected: themeMode == ThemeMode.system,
                  isDark: isDark,
                  onTap: () => onChanged(ThemeMode.system),
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'Dark',
                  icon: Icons.dark_mode_rounded,
                  selected: themeMode == ThemeMode.dark,
                  isDark: isDark,
                  onTap: () => onChanged(ThemeMode.dark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _modeLabel(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'Light mode active';
      case ThemeMode.dark:
        return 'Dark mode active';
      case ThemeMode.system:
        return 'Follows system setting';
    }
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : (isDark ? AppColors.slate800 : AppColors.slate100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? Colors.white
                    : (isDark ? AppColors.slate500 : AppColors.slate400),
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : (isDark ? AppColors.slate500 : AppColors.slate400),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumTile extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;

  const _PremiumTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    required this.isDark,
  });

  @override
  State<_PremiumTile> createState() => _PremiumTileState();
}

class _PremiumTileState extends State<_PremiumTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isDark ? AppColors.slate700 : AppColors.slate200,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        widget.iconColor.withValues(alpha: widget.isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDark
                              ? AppColors.slate500
                              : AppColors.slate400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
