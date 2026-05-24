/// Smart Umbrella App - Lighting Screen
///
/// Full lighting control with color picker, brightness slider,
/// and lighting mode selection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/lighting_provider.dart';
import '../../../state/device_provider.dart';
import '../../../device/models/umbrella_state.dart';

class LightingScreen extends ConsumerStatefulWidget {
  const LightingScreen({super.key});

  @override
  ConsumerState<LightingScreen> createState() => _LightingScreenState();
}

class _LightingScreenState extends ConsumerState<LightingScreen> {
  Color _selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Initialize with current color
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentColor = ref.read(lightColorProvider);
      setState(() => _selectedColor = currentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lighting = ref.watch(lightingStateProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final presetColors = ref.watch(presetColorsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Custom header
          SliverToBoxAdapter(
            child: _LightingHeader(isDark: isDark, isOn: lighting.isOn),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
            // Light Preview Card
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                gradient: lighting.isOn
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          lighting.effectiveColor,
                          lighting.effectiveColor.withValues(alpha: 0.7),
                        ],
                      )
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
                boxShadow: lighting.isOn
                    ? [
                        BoxShadow(
                          color: lighting.effectiveColor.withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                          lighting.isOn
                              ? Icons.lightbulb
                              : Icons.lightbulb_outline,
                          color: lighting.isOn
                              ? Colors.white
                              : AppColors.warmGray500,
                          size: 48,
                        )
                        .animate(target: lighting.isOn ? 1 : 0)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.0, 1.0),
                          duration: 300.ms,
                        ),
                    const SizedBox(height: 8),
                    Text(
                      lighting.isOn ? 'Lights On' : 'Lights Off',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: lighting.isOn
                            ? Colors.white
                            : AppColors.warmGray500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 32),

            // Power Toggle
            _buildSection(
              context,
              title: 'Power',
              child: SwitchListTile(
                title: Text(
                  lighting.isOn ? 'On' : 'Off',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                value: lighting.isOn,
                onChanged: isConnected
                    ? (_) => ref.read(lightingControlProvider.notifier).toggle()
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            // Brightness Slider
            _buildSection(
              context,
              title: 'Brightness',
              trailing: '${lighting.brightness}%',
              child: Slider(
                value: lighting.brightness.toDouble(),
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: isConnected && lighting.isOn
                    ? (value) {
                        ref
                            .read(lightingControlProvider.notifier)
                            .setBrightness(value.round());
                      }
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            // Preset Colors
            _buildSection(
              context,
              title: 'Quick Colors',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: presetColors.map((color) {
                  final isSelected =
                      _selectedColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: isConnected && lighting.isOn
                        ? () {
                            setState(() => _selectedColor = color);
                            ref
                                .read(lightingControlProvider.notifier)
                                .setColor(color);
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Color Picker
            _buildSection(
              context,
              title: 'Custom Color',
              child: ColorPicker(
                color: _selectedColor,
                enableShadesSelection: false,
                pickersEnabled: const {
                  ColorPickerType.wheel: true,
                  ColorPickerType.accent: false,
                  ColorPickerType.primary: false,
                },
                wheelDiameter: 220,
                wheelWidth: 20,
                onColorChanged: isConnected && lighting.isOn
                    ? (color) {
                        setState(() => _selectedColor = color);
                        ref
                            .read(lightingControlProvider.notifier)
                            .setColor(color);
                      }
                    : (color) {},
              ),
            ),

            const SizedBox(height: 24),

            // Lighting Modes
            _buildSection(
              context,
              title: 'Lighting Mode',
              child: Column(
                children: LightingMode.values.map((mode) {
                  final isSelected = lighting.mode == mode;
                  return _LightingModeCard(
                    mode: mode,
                    isSelected: isSelected,
                    isEnabled: isConnected,
                    onTap: () {
                      ref.read(lightingControlProvider.notifier).setMode(mode);
                    },
                  );
                }).toList(),
              ),
            ),

              const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    String? trailing,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _LightingModeCard extends StatelessWidget {
  final LightingMode mode;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _LightingModeCard({
    required this.mode,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, label, description, color) = _getModeData();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? AppColors.warmGray700 : AppColors.warmGray200),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected) Icon(Icons.check_circle, color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  (IconData, String, String, Color) _getModeData() {
    switch (mode) {
      case LightingMode.off:
        return (
          Icons.lightbulb_outline,
          'Off',
          'Lights turned off',
          AppColors.warmGray500,
        );
      case LightingMode.static:
        return (Icons.lightbulb, 'Static', 'Solid color', AppColors.primary);
      case LightingMode.ambient:
        return (
          Icons.auto_awesome,
          'Ambient',
          'Slow color transitions',
          AppColors.ambient,
        );
      case LightingMode.party:
        return (
          Icons.celebration,
          'Party',
          'Dynamic color effects',
          AppColors.party,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Lighting Screen Header
// ─────────────────────────────────────────────────────────────
class _LightingHeader extends StatelessWidget {
  final bool isDark;
  final bool isOn;
  const _LightingHeader({required this.isDark, required this.isOn});

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
              ? [const Color(0xFF1A1028), const Color(0xFF120E20)]
              : [const Color(0xFFF5F0FF), const Color(0xFFEDE8FF)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.lightbulb_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lighting Control',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                  ),
                ),
                Text(
                  isOn ? '● Active' : '○ Off',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOn
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
