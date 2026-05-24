/// Smart Umbrella App – App Shell with Persistent Floating Island Nav Bar
///
/// This shell wraps all main screens and provides the persistent nav bar.
/// Uses GoRouter's StatefulShellRoute location to track the active tab.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../../state/device_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _navEnterCtrl;

  @override
  void initState() {
    super.initState();
    _navEnterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _navEnterCtrl.dispose();
    super.dispose();
  }

  static const _navItems = [
    _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home', RoutePaths.dashboard),
    _NavItem(Icons.lightbulb_rounded, Icons.lightbulb_outline_rounded, 'Lights', RoutePaths.lighting),
    _NavItem(Icons.music_note_rounded, Icons.music_note_outlined, 'Sound', RoutePaths.sound),
    _NavItem(Icons.battery_charging_full_rounded, Icons.battery_charging_full_outlined, 'Battery', RoutePaths.battery),
  ];

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    if (index == widget.navigationShell.currentIndex) {
      // Already on this tab – no-op (or scroll to top in future)
      return;
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaBottom = MediaQuery.of(context).padding.bottom;
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // ── Page content ───────────────────────────────────
          widget.navigationShell,

          // ── Connection banner (offline) ────────────────────
          if (!isConnected)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: _ConnectionBanner(isDark: isDark)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.5, end: 0),
            ),

          // ── Floating Island Nav Bar ────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _navEnterCtrl,
              builder: (_, child) => Opacity(
                opacity: _navEnterCtrl.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - _navEnterCtrl.value) * 80),
                  child: child,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, mediaBottom + 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface.withValues(alpha: 0.90)
                            : Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : AppColors.primary.withValues(alpha: 0.10),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.45)
                                : AppColors.primary.withValues(alpha: 0.14),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(_navItems.length, (i) {
                            final item = _navItems[i];
                            final isSelected = i == currentIndex;
                            return _IslandNavItem(
                              icon: isSelected ? item.activeIcon : item.icon,
                              label: item.label,
                              isSelected: isSelected,
                              isDark: isDark,
                              onTap: () => _onTabTap(i),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Nav Item Data
// ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final String path;

  const _NavItem(this.activeIcon, this.icon, this.label, this.path);
}

// ─────────────────────────────────────────────────────────────
// Island Nav Item
// ─────────────────────────────────────────────────────────────
class _IslandNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _IslandNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_IslandNavItem> createState() => _IslandNavItemState();
}

class _IslandNavItemState extends State<_IslandNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.86).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inactiveColor =
        widget.isDark ? AppColors.slate500 : AppColors.slate400;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          padding: EdgeInsets.symmetric(
              horizontal: widget.isSelected ? 20 : 14, vertical: 9),
          decoration: BoxDecoration(
            gradient: widget.isSelected ? AppColors.heroGradient : null,
            color: widget.isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.40),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: widget.isSelected
                ? Row(
                    key: ValueKey('sel_${widget.label}'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 19),
                      const SizedBox(width: 6),
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : Icon(
                    widget.icon,
                    key: ValueKey('icon_${widget.label}'),
                    color: inactiveColor,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Offline Connection Banner
// ─────────────────────────────────────────────────────────────
class _ConnectionBanner extends StatelessWidget {
  final bool isDark;
  const _ConnectionBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1.3, 1.3),
                    duration: 700.ms,
                  ),
              const SizedBox(width: 10),
              Text(
                'Device Offline – Simulation Mode',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
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
