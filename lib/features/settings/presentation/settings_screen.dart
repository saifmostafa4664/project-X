/// Smart Umbrella App - Settings Screen
///
/// App settings including simulation mode toggle, theme selection,
/// and debug access.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../state/device_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSimulation = ref.watch(simulationModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // App Info Section
          _buildSectionHeader(context, 'App'),
          _SettingsTile(
            icon: Icons.beach_access,
            iconColor: AppColors.primary,
            title: AppStrings.appName,
            subtitle: 'Version 1.0.0',
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Connection Section
          _buildSectionHeader(context, 'Connection'),
          _SettingsTile(
            icon: Icons.developer_mode,
            iconColor: AppColors.sunset,
            title: 'Simulation Mode',
            subtitle: isSimulation
                ? 'Using fake device for testing'
                : 'Connecting to real hardware',
            trailing: Switch(
              value: isSimulation,
              onChanged: (value) {
                ref.read(simulationModeProvider.notifier).state = value;
              },
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.bug_report,
            iconColor: AppColors.warning,
            title: 'Debug Panel',
            subtitle: 'Simulate device states',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.debug),
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          _SettingsTile(
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            iconColor: isDark ? AppColors.ambient : AppColors.solar,
            title: 'Theme',
            subtitle: isDark ? 'Dark mode' : 'Light mode',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Theme switching would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme follows system settings')),
              );
            },
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          _SettingsTile(
            icon: Icons.info_outline,
            iconColor: AppColors.info,
            title: 'About Smart Umbrella',
            subtitle: 'Learn more about this app',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.success,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.description_outlined,
            iconColor: AppColors.primary,
            title: 'Terms of Service',
            subtitle: 'Usage terms and conditions',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
            isDark: isDark,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.warmGray500,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.beach_access, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(AppStrings.appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'The Smart Umbrella app lets you control your intelligent beach umbrella with solar panels, RGB lighting, and built-in sound system.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text('Version 1.0.0', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.warmGray700 : AppColors.warmGray200,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.warmGray400
                              : AppColors.warmGray500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
