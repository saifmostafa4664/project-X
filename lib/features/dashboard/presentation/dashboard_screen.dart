/// Smart Umbrella App – Premium Dashboard Screen
/// v2: Floating island nav, aurora header, profile integration, parallax
library;

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../state/device_provider.dart';
import '../../../state/lighting_provider.dart';
import '../../../state/sound_provider.dart';
import '../../../state/battery_provider.dart';
import '../../../state/user_profile.dart';
import 'widgets/umbrella_control_card.dart';
import 'widgets/quick_control_card.dart';
import 'widgets/battery_status_card.dart';
import 'widgets/companion_message_banner.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late ScrollController _scrollCtrl;
  late AnimationController _auroraCtrl;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()
      ..addListener(() {
        setState(() => _scrollOffset = _scrollCtrl.offset);
      });
    _auroraCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceConnectionProvider.notifier).connect();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _auroraCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final battery = ref.watch(batteryStateProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────
          CustomScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Aurora Header ──────────────────────────────
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _AuroraHeader(
                    auroraCtrl: _auroraCtrl,
                    isDark: isDark,
                    scrollOffset: _scrollOffset,
                    profile: profile,
                    isConnected: isConnected,
                    onProfileTap: () => context.push(RoutePaths.profile),
                    onSettingsTap: () => context.push(RoutePaths.settings),
                    greeting: _greeting(),
                  ),
                ),
              ),

              // ── Environment Strip ─────────────────────────
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: Offset(0, -_scrollOffset * 0.04),
                  child: _EnvironmentStrip(
                    battery: battery.percentage,
                    isConnected: isConnected,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.15, end: 0),
                ),
              ),

              // ── Companion Message ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const CompanionMessageBanner()
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms),
                ),
              ),

              // ── Umbrella Hero Card ─────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: const UmbrellaControlCard()
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0),
                ),
              ),

              // ── Battery Card ───────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: const BatteryStatusCard()
                      .animate()
                      .fadeIn(delay: 220.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0),
                ),
              ),

              // ── Stats Row ─────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _StatsRow(isConnected: isConnected, profile: profile)
                      .animate()
                      .fadeIn(delay: 280.ms, duration: 500.ms),
                ),
              ),

              // ── Quick Controls ─────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Quick Controls',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(delay: 320.ms, duration: 400.ms),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildLightingCard(context, ref, isConnected)
                            .animate()
                            .fadeIn(delay: 350.ms, duration: 500.ms)
                            .slideX(begin: -0.1, end: 0),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildSoundCard(context, ref, isConnected)
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 500.ms)
                            .slideX(begin: 0.1, end: 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Floating Island Nav Bar ────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FloatingIslandNav(
              selectedIndex: _selectedIndex,
              onTap: (i) {
                HapticFeedback.selectionClick();
                setState(() => _selectedIndex = i);
                switch (i) {
                  case 0:
                    break; // already on dashboard
                  case 1:
                    context.push(RoutePaths.lighting);
                  case 2:
                    context.push(RoutePaths.sound);
                  case 3:
                    context.push(RoutePaths.battery);
                }
              },
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.6, end: 0),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildLightingCard(
      BuildContext context, WidgetRef ref, bool isConnected) {
    final lighting = ref.watch(lightingStateProvider);
    return QuickControlCard(
      title: 'Lighting',
      subtitle: lighting.isOn ? 'On · ${lighting.brightness}%' : 'Off',
      icon: lighting.isOn
          ? Icons.lightbulb_rounded
          : Icons.lightbulb_outline_rounded,
      iconColor: lighting.isOn ? lighting.color : AppColors.amber,
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
      BuildContext context, WidgetRef ref, bool isConnected) {
    final sound = ref.watch(soundStateProvider);
    return QuickControlCard(
      title: 'Sound',
      subtitle: sound.isPlaying ? 'Playing · ${sound.volume}%' : 'Paused',
      icon: sound.isPlaying
          ? Icons.volume_up_rounded
          : Icons.volume_off_rounded,
      iconColor: sound.isPlaying ? AppColors.teal : AppColors.rose,
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

// ─────────────────────────────────────────────────────────────
// Aurora Header
// ─────────────────────────────────────────────────────────────
class _AuroraHeader extends StatelessWidget {
  final AnimationController auroraCtrl;
  final bool isDark;
  final double scrollOffset;
  final UserProfile profile;
  final bool isConnected;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final String greeting;

  const _AuroraHeader({
    required this.auroraCtrl,
    required this.isDark,
    required this.scrollOffset,
    required this.profile,
    required this.isConnected,
    required this.onProfileTap,
    required this.onSettingsTap,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: auroraCtrl,
      builder: (ctx, _) => Stack(
        children: [
          // Aurora blobs background
          ClipRect(
            child: CustomPaint(
              size: Size(MediaQuery.of(ctx).size.width, 140),
              painter: _AuroraPainter(
                progress: auroraCtrl.value,
                isDark: isDark,
              ),
            ),
          ),
          // Frosted overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(color: Colors.transparent),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // App logo chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.beach_access_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              AppStrings.appName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Connection badge
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isConnected
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isConnected
                                ? AppColors.success.withValues(alpha: 0.3)
                                : AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isConnected
                                    ? AppColors.success
                                    : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            )
                                .animate(
                                    onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.2, 1.2),
                                  duration: 800.ms,
                                ),
                            const SizedBox(width: 6),
                            Text(
                              isConnected ? 'Connected' : 'Offline',
                              style: TextStyle(
                                color: isConnected
                                    ? AppColors.success
                                    : AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Settings
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: onSettingsTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.slate700
                                    : AppColors.slate200,
                              ),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: isDark
                                  ? AppColors.primaryLight
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good $greeting, ${profile.name} 👋',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.slate100
                                    : AppColors.slate900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Profile avatar button
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.heroGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              profile.avatarEmoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Aurora Painter
// ─────────────────────────────────────────────────────────────
class _AuroraPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  const _AuroraPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * math.pi * 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
    );

    void drawBlob(double bx, double by, double r1, double r2, Color col, double alpha) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [col.withValues(alpha: alpha), col.withValues(alpha: 0.0)],
        ).createShader(
          Rect.fromCenter(
              center: Offset(bx, by), width: r1 * 2, height: r2 * 2),
        )
        ..blendMode = BlendMode.srcOver;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(bx, by), width: r1 * 2, height: r2 * 2),
          paint);
    }

    // Red blob – top left drifting
    drawBlob(
      size.width * 0.15 + math.sin(t * 0.7) * 30,
      size.height * 0.3 + math.cos(t * 0.5) * 20,
      130, 90,
      AppColors.primary,
      isDark ? 0.22 : 0.14,
    );

    // Teal blob – top right drifting
    drawBlob(
      size.width * 0.8 + math.cos(t * 0.6) * 25,
      size.height * 0.2 + math.sin(t * 0.8) * 18,
      110, 80,
      AppColors.teal,
      isDark ? 0.18 : 0.12,
    );

    // Small accent blob center
    drawBlob(
      size.width * 0.5 + math.sin(t * 1.1) * 20,
      size.height * 0.6 + math.cos(t * 0.9) * 12,
      70, 50,
      AppColors.amber,
      isDark ? 0.10 : 0.07,
    );
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.progress != progress || old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────
// Floating Island Nav Bar
// ─────────────────────────────────────────────────────────────
class _FloatingIslandNav extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _FloatingIslandNav({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<_FloatingIslandNav> createState() => _FloatingIslandNavState();
}

class _FloatingIslandNavState extends State<_FloatingIslandNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _indicatorCtrl;

  @override
  void initState() {
    super.initState();
    _indicatorCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
  }

  @override
  void dispose() {
    _indicatorCtrl.dispose();
    super.dispose();
  }

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Home'),
    (Icons.lightbulb_rounded, Icons.lightbulb_outline_rounded, 'Lights'),
    (Icons.music_note_rounded, Icons.music_note_outlined, 'Sound'),
    (Icons.battery_charging_full_rounded, Icons.battery_charging_full_outlined, 'Battery'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaBottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, mediaBottom + 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.88)
                  : Colors.white.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.primary.withValues(alpha: 0.10),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (i) {
                  final isSelected = i == widget.selectedIndex;
                  final item = _items[i];
                  return _IslandNavItem(
                    icon: isSelected ? item.$1 : item.$2,
                    label: item.$3,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () => widget.onTap(i),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
        vsync: this, duration: const Duration(milliseconds: 220));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
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
    final activeColor =
        widget.isDark ? AppColors.primaryLight : AppColors.primary;
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
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          padding: EdgeInsets.symmetric(
              horizontal: widget.isSelected ? 20 : 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? AppColors.heroGradient
                : null,
            color: widget.isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: widget.isSelected
                ? Row(
                    key: ValueKey(widget.label),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 20),
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
// Environment Strip
// ─────────────────────────────────────────────────────────────
class _EnvironmentStrip extends StatelessWidget {
  final int battery;
  final bool isConnected;

  const _EnvironmentStrip({
    required this.battery,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.slate700 : AppColors.slate200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _EnvItem(
              icon: Icons.thermostat_rounded,
              color: AppColors.rose,
              value: '28°C',
              label: 'Temp',
            ),
            _divider(isDark),
            _EnvItem(
              icon: Icons.wb_sunny_rounded,
              color: AppColors.amber,
              value: 'UV 7',
              label: 'Index',
            ),
            _divider(isDark),
            _EnvItem(
              icon: Icons.air_rounded,
              color: AppColors.teal,
              value: '12 km/h',
              label: 'Wind',
            ),
            _divider(isDark),
            _EnvItem(
              icon: Icons.battery_charging_full_rounded,
              color: battery > 20 ? AppColors.success : AppColors.error,
              value: '$battery%',
              label: 'Battery',
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) => Container(
        height: 30,
        width: 1,
        color: isDark ? AppColors.slate700 : AppColors.slate200,
      );
}

class _EnvItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _EnvItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool isConnected;
  final UserProfile profile;

  const _StatsRow({required this.isConnected, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mins = profile.totalUsageMinutes;
    final timeLabel = mins < 60 ? '${mins}m' : '${mins ~/ 60}h${mins % 60 > 0 ? ' ${mins % 60}m' : ''}';

    return Row(
      children: [
        _StatChip(
          icon: Icons.solar_power_rounded,
          label: 'Solar',
          value: '2.4W',
          color: AppColors.amber,
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatChip(
          icon: Icons.timer_outlined,
          label: 'Time',
          value: profile.totalUsageMinutes == 0 ? '—' : timeLabel,
          color: AppColors.primary,
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatChip(
          icon: Icons.beach_access_rounded,
          label: 'Sessions',
          value: profile.totalSessions == 0 ? '—' : '${profile.totalSessions}',
          color: AppColors.teal,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.2 : 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
