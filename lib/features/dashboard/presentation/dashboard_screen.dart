/// Smart Umbrella App - Dashboard Screen
///
/// Main control hub displaying all umbrella controls, status indicators,
/// and quick access to features. Premium beach-friendly design with
/// smooth animations.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../state/device_provider.dart';
import '../../../state/lighting_provider.dart';
import '../../../state/sound_provider.dart';
import 'widgets/umbrella_control_card.dart';
import 'widgets/quick_control_card.dart';
import 'widgets/battery_status_card.dart';
import 'widgets/companion_message_banner.dart';
import 'widgets/connection_status_badge.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-connect on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceConnectionProvider.notifier).connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Row(
                  children: [
                    Icon(
                      Icons.beach_access,
                      color: isDark
                          ? AppColors.primaryLight
                          : AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.warmGray100
                                : AppColors.warmGray900,
                          ),
                    ),
                  ],
                ),
              ),
              actions: [
                const ConnectionStatusBadge(),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(RoutePaths.settings),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Companion Message Banner
            SliverToBoxAdapter(
              child: const CompanionMessageBanner()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.2, end: 0),
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Umbrella Control Card (Hero)
                  const UmbrellaControlCard()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Battery Status
                  const BatteryStatusCard()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Quick Controls Grid
                  Text(
                    'Quick Controls',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Lighting Quick Control
                      Expanded(
                        child: _buildLightingCard(context, ref, isConnected)
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 350.ms)
                            .slideX(begin: -0.1, end: 0),
                      ),
                      const SizedBox(width: 16),
                      // Sound Quick Control
                      Expanded(
                        child: _buildSoundCard(context, ref, isConnected)
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 400.ms)
                            .slideX(begin: 0.1, end: 0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100), // Bottom padding for navigation
                ]),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: true,
                  onTap: () {},
                ),
                _NavItem(
                  icon: Icons.lightbulb_outline_rounded,
                  label: 'Lights',
                  onTap: () => context.push(RoutePaths.lighting),
                ),
                _NavItem(
                  icon: Icons.music_note_rounded,
                  label: 'Sound',
                  onTap: () => context.push(RoutePaths.sound),
                ),
                _NavItem(
                  icon: Icons.battery_charging_full_rounded,
                  label: 'Battery',
                  onTap: () => context.push(RoutePaths.battery),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLightingCard(
    BuildContext context,
    WidgetRef ref,
    bool isConnected,
  ) {
    final lighting = ref.watch(lightingStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return QuickControlCard(
      title: 'Lighting',
      subtitle: lighting.isOn ? 'On • ${lighting.brightness}%' : 'Off',
      icon: lighting.isOn
          ? Icons.lightbulb_rounded
          : Icons.lightbulb_outline_rounded,
      iconColor: lighting.isOn
          ? lighting.color
          : (isDark ? AppColors.warmGray500 : AppColors.warmGray400),
      isActive: lighting.isOn,
      isEnabled: isConnected,
      onTap: () => context.push(RoutePaths.lighting),
      onToggle: () {
        if (isConnected) {
          ref.read(lightingControlProvider.notifier).toggle();
        }
      },
    );
  }

  Widget _buildSoundCard(
    BuildContext context,
    WidgetRef ref,
    bool isConnected,
  ) {
    final sound = ref.watch(soundStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return QuickControlCard(
      title: 'Sound',
      subtitle: sound.isPlaying ? 'Playing • ${sound.volume}%' : 'Paused',
      icon: sound.isPlaying
          ? Icons.volume_up_rounded
          : Icons.volume_off_rounded,
      iconColor: sound.isPlaying
          ? AppColors.primary
          : (isDark ? AppColors.warmGray500 : AppColors.warmGray400),
      isActive: sound.isPlaying,
      isEnabled: isConnected,
      onTap: () => context.push(RoutePaths.sound),
      onToggle: () {
        if (isConnected) {
          ref.read(soundControlProvider.notifier).togglePlayback();
        }
      },
    );
  }
}

/// Navigation item widget
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.warmGray500
        : AppColors.warmGray400;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
