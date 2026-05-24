/// Smart Umbrella App - Sound Screen
///
/// Sound system control with play/pause, volume control,
/// and playback status display.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/sound_provider.dart';
import '../../../state/device_provider.dart';

class SoundScreen extends ConsumerWidget {
  const SoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sound = ref.watch(soundStateProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _SoundHeader(isDark: isDark, isPlaying: sound.isPlaying),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
            // Now Playing Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: sound.isPlaying
                    ? AppColors.oceanGradient
                    : LinearGradient(
                        colors: [
                          isDark
                              ? AppColors.warmGray800
                              : AppColors.warmGray200,
                          isDark
                              ? AppColors.warmGray700
                              : AppColors.warmGray300,
                        ],
                      ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: sound.isPlaying
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  // Album art placeholder
                  Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          sound.isPlaying
                              ? Icons.music_note_rounded
                              : Icons.music_off_rounded,
                          size: 56,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      )
                      .animate(target: sound.isPlaying ? 1 : 0)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.0, 1.0),
                      )
                      .then()
                      .shimmer(
                        duration: 2000.ms,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),

                  const SizedBox(height: 24),

                  // Track name
                  Text(
                    sound.currentTrack ?? 'No track playing',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    sound.isPlaying ? 'Now Playing' : 'Paused',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Playback controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Skip previous (placeholder)
                      IconButton(
                        onPressed: isConnected ? () {} : null,
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white.withValues(
                            alpha: isConnected ? 0.7 : 0.3,
                          ),
                          size: 36,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Play/Pause button
                      GestureDetector(
                        onTap: isConnected
                            ? () => ref
                                  .read(soundControlProvider.notifier)
                                  .togglePlayback()
                            : null,
                        child:
                            Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    sound.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                )
                                .animate(target: sound.isPlaying ? 1 : 0)
                                .scale(
                                  begin: const Offset(1.0, 1.0),
                                  end: const Offset(1.05, 1.05),
                                  curve: Curves.easeInOut,
                                ),
                      ),

                      const SizedBox(width: 16),

                      // Skip next (placeholder)
                      IconButton(
                        onPressed: isConnected ? () {} : null,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white.withValues(
                            alpha: isConnected ? 0.7 : 0.3,
                          ),
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 32),

            // Volume Control Card
            Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.warmGray700
                          : AppColors.warmGray200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Volume',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${sound.volume}%',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.volume_mute_rounded,
                            color: isDark
                                ? AppColors.warmGray500
                                : AppColors.warmGray400,
                          ),
                          Expanded(
                            child: Slider(
                              value: sound.volume.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              onChanged: isConnected
                                  ? (value) {
                                      ref
                                          .read(soundControlProvider.notifier)
                                          .setVolume(value.round());
                                    }
                                  : null,
                            ),
                          ),
                          Icon(
                            Icons.volume_up_rounded,
                            color: isDark
                                ? AppColors.warmGray500
                                : AppColors.warmGray400,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 100.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Quick volume buttons
            Row(
              children: [
                _VolumeButton(
                  icon: Icons.volume_off_rounded,
                  label: 'Mute',
                  isActive: sound.volume == 0,
                  onTap: isConnected
                      ? () =>
                            ref.read(soundControlProvider.notifier).setVolume(0)
                      : null,
                ),
                const SizedBox(width: 12),
                _VolumeButton(
                  icon: Icons.volume_down_rounded,
                  label: '25%',
                  isActive: sound.volume == 25,
                  onTap: isConnected
                      ? () => ref
                            .read(soundControlProvider.notifier)
                            .setVolume(25)
                      : null,
                ),
                const SizedBox(width: 12),
                _VolumeButton(
                  icon: Icons.volume_down_rounded,
                  label: '50%',
                  isActive: sound.volume == 50,
                  onTap: isConnected
                      ? () => ref
                            .read(soundControlProvider.notifier)
                            .setVolume(50)
                      : null,
                ),
                const SizedBox(width: 12),
                _VolumeButton(
                  icon: Icons.volume_up_rounded,
                  label: '100%',
                  isActive: sound.volume == 100,
                  onTap: isConnected
                      ? () => ref
                            .read(soundControlProvider.notifier)
                            .setVolume(100)
                      : null,
                ),
              ],
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

            const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _VolumeButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                  : (isDark ? AppColors.warmGray700 : AppColors.warmGray200),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive
                    ? Colors.white
                    : (isDark ? AppColors.warmGray400 : AppColors.warmGray500),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? Colors.white
                      : (isDark
                            ? AppColors.warmGray400
                            : AppColors.warmGray500),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sound Screen Header
// ─────────────────────────────────────────────────────────────
class _SoundHeader extends StatelessWidget {
  final bool isDark;
  final bool isPlaying;
  const _SoundHeader({required this.isDark, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0F1F2A), const Color(0xFF0A1520)]
              : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.music_note_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sound System',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF134E4A),
                  ),
                ),
                Text(
                  isPlaying ? '♪ Now Playing' : '○ Paused',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPlaying
                        ? const Color(0xFF10B981)
                        : (isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
