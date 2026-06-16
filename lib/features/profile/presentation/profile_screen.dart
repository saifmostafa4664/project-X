library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/user_profile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _editingName = false;
  late TextEditingController _nameCtrl;

  static const _avatarEmojis = [
    '🏖️', '☂️', '🌊', '🏄', '🌞', '🐚', '⛵', '🦀',
    '🐠', '🐬', '🦈', '🌺', '🍹', '🎯', '🎪', '🚀',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameCtrl = TextEditingController(text: profile.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            GestureDetector(
                              onTap: () => _showAvatarPicker(context, profile),
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 2.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    profile.avatarEmoji,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _editingName
                                ? SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _nameCtrl,
                                      autofocus: true,
                                      maxLength: UserProfileNotifier.maxNameLength,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        filled: false,
                                        hintText: 'Your name',
                                        hintStyle: TextStyle(
                                            color: Colors.white60),
                                      ),
                                      onSubmitted: (v) => _saveName(v),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () =>
                                        setState(() => _editingName = true),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          profile.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(
                                            Icons.edit_rounded,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(height: 6),
                            Text(
                              'Member since ${_formatDate(profile.memberSince)}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Your Activity', isDark),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.timer_outlined,
                        label: 'Total Time',
                        value: _formatMinutes(profile.totalUsageMinutes),
                        color: AppColors.teal,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.beach_access_rounded,
                        label: 'Sessions',
                        value: '${profile.totalSessions}',
                        color: AppColors.primary,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.wb_sunny_rounded,
                        label: 'UV Days',
                        value: '${(profile.totalSessions / 2).ceil()}',
                        color: AppColors.amber,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Recent Sessions', isDark),
                  const SizedBox(height: 12),
                  if (profile.recentSessions.isEmpty)
                    _EmptySessionsCard(isDark: isDark)
                  else
                    ...profile.recentSessions
                        .take(5)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (e) => _SessionTile(
                            session: e.value,
                            isDark: isDark,
                          )
                              .animate()
                              .fadeIn(delay: (120 + e.key * 60).ms),
                        ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => _addDemoSession(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.tealGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Log a Test Session',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: isDark ? AppColors.slate400 : AppColors.slate500,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  void _saveName(String v) {
    setState(() => _editingName = false);
    ref.read(userProfileProvider.notifier).updateName(v);
    HapticFeedback.lightImpact();
  }

  void _showAvatarPicker(BuildContext context, UserProfile profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape:
          const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Avatar',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _avatarEmojis.map((e) {
                final isSelected = e == profile.avatarEmoji;
                return GestureDetector(
                  onTap: () {
                    ref.read(userProfileProvider.notifier).updateAvatar(e);
                    Navigator.pop(ctx);
                    HapticFeedback.selectionClick();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : (isDark ? AppColors.darkSurfaceElevated : AppColors.slate100),
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(child: Text(e, style: const TextStyle(fontSize: 28))),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _addDemoSession() {
    final modes = ['Beach', 'Party', 'Relax', 'Sport'];
    final mode = modes[DateTime.now().millisecondsSinceEpoch % modes.length];
    ref.read(userProfileProvider.notifier).addSession(
          durationMinutes: 30 + (DateTime.now().minute % 60),
          mode: mode,
        );
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$mode session logged!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  String _formatMinutes(int mins) {
    if (mins < 60) return '${mins}m';
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.slate100 : AppColors.slate900,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.slate400 : AppColors.slate500,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final SessionRecord session;
  final bool isDark;

  const _SessionTile({required this.session, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final modeColor = _modeColor(session.mode);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: modeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.beach_access_rounded, color: modeColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${session.mode} Session',
                  style: TextStyle(
                    color: isDark ? AppColors.slate100 : AppColors.slate900,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatDate(session.date),
                  style: TextStyle(
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: modeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${session.durationMinutes}m',
              style: TextStyle(
                color: modeColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _modeColor(String mode) {
    switch (mode) {
      case 'Party':
        return AppColors.rose;
      case 'Relax':
        return AppColors.teal;
      case 'Sport':
        return AppColors.amber;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

class _EmptySessionsCard extends StatelessWidget {
  final bool isDark;
  const _EmptySessionsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Column(
        children: [
          const Text('🏖️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text(
            'No sessions yet',
            style: TextStyle(
              color: isDark ? AppColors.slate300 : AppColors.slate700,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Open your umbrella to start\nyour first beach session!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? AppColors.slate500 : AppColors.slate400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
