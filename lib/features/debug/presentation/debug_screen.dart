library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/themed_surface_container.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../state/device_provider.dart';
import '../../../device/fake_umbrella_device.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  bool _forceLowBattery = false;
  bool _forceStrongSunlight = false;
  bool _forceOffline = false;

  FakeUmbrellaDevice? get _fakeDevice {
    final device = ref.read(deviceProvider);
    if (device is FakeUmbrellaDevice) {
      return device;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final device = _fakeDevice;
      if (device != null) {
        final flags = device.debugFlags;
        setState(() {
          _forceLowBattery = flags['forceLowBattery'] ?? false;
          _forceStrongSunlight = flags['forceStrongSunlight'] ?? false;
          _forceOffline = flags['forceDisconnected'] ?? false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSimulation = ref.watch(simulationModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Panel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (!isSimulation)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_rounded, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Debug controls are only available in Simulation Mode. Enable it in Settings.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.warningDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Simulation Mode',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.infoDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Use these controls to test how the app behaves under different device conditions.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.infoDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Text(
            'Simulate Conditions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          _DebugToggle(
            icon: Icons.battery_1_bar_rounded,
            iconColor: AppColors.error,
            title: 'Low Battery',
            subtitle: 'Force battery to 15%',
            value: _forceLowBattery,
            isEnabled: isSimulation,
            onChanged: (value) {
              setState(() => _forceLowBattery = value);
              _fakeDevice?.forceLowBattery(value);
            },
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          _DebugToggle(
            icon: Icons.wb_sunny_rounded,
            iconColor: AppColors.solar,
            title: 'Strong Sunlight',
            subtitle: 'Simulate 45W solar input',
            value: _forceStrongSunlight,
            isEnabled: isSimulation,
            onChanged: (value) {
              setState(() => _forceStrongSunlight = value);
              _fakeDevice?.forceStrongSunlight(value);
            },
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          _DebugToggle(
            icon: Icons.wifi_off_rounded,
            iconColor: AppColors.warmGray500,
            title: 'Device Offline',
            subtitle: 'Simulate connection loss',
            value: _forceOffline,
            isEnabled: isSimulation,
            onChanged: (value) {
              setState(() => _forceOffline = value);
              _fakeDevice?.forceDisconnected(value);
            },
            isDark: isDark,
          ),

          const SizedBox(height: 32),

          Text(
            'Actions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          _DebugButton(
            icon: Icons.refresh_rounded,
            iconColor: AppColors.primary,
            title: 'Reset All Flags',
            subtitle: 'Clear all debug conditions',
            isEnabled: isSimulation,
            onTap: () {
              setState(() {
                _forceLowBattery = false;
                _forceStrongSunlight = false;
                _forceOffline = false;
              });
              _fakeDevice?.forceLowBattery(false);
              _fakeDevice?.forceStrongSunlight(false);
              _fakeDevice?.forceDisconnected(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All debug flags reset')),
              );
            },
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          _DebugButton(
            icon: Icons.link_rounded,
            iconColor: AppColors.success,
            title: 'Force Reconnect',
            subtitle: 'Attempt to reconnect to device',
            isEnabled: isSimulation && _forceOffline == false,
            onTap: () async {
              try {
                await ref.read(deviceConnectionProvider.notifier).connect();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reconnection successful')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              }
            },
            isDark: isDark,
          ),

          const SizedBox(height: 40),

          Text(
            'Technical Info',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.warmGray800 : AppColors.warmGray100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow('Mode', isSimulation ? 'Simulation' : 'Hardware'),
                const Divider(height: 24),
                _InfoRow('Device Type', 'FakeUmbrellaDevice'),
                const Divider(height: 24),
                _InfoRow('Protocol', 'In-Memory (Mock)'),
                const Divider(height: 24),
                _InfoRow('Refresh Rate', '5 seconds'),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _DebugToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final bool isDark;

  const _DebugToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isEnabled,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceContainer(
      borderRadius: 16,
      borderColor: value
          ? iconColor.withValues(alpha: 0.5)
          : null,
      borderWidth: value ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconBadge(icon: icon, color: iconColor),
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
            Switch(value: value, onChanged: isEnabled ? onChanged : null),
          ],
        ),
      ),
    );
  }
}

class _DebugButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isEnabled;
  final VoidCallback onTap;
  final bool isDark;

  const _DebugButton({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceContainer(
      borderRadius: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconBadge(
                  icon: icon,
                  color: iconColor.withValues(alpha: isEnabled ? 1.0 : 0.3),
                  backgroundAlpha: isEnabled ? 0.15 : 0.05,
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
                          color: isEnabled ? null : AppColors.warmGray400,
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
                Icon(
                  Icons.chevron_right,
                  color: isEnabled ? null : AppColors.warmGray400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.warmGray500),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
