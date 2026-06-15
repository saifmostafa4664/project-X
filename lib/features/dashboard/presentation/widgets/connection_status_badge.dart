library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../state/device_provider.dart';
import '../../../../device/models/umbrella_state.dart';

class ConnectionStatusBadge extends ConsumerWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusProvider);

    final (color, icon, label) = _getStatusStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(
            color: color,
            isPulsing: status == ConnectionStatus.connecting,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData, String) _getStatusStyle(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return (AppColors.success, Icons.wifi_rounded, 'Connected');
      case ConnectionStatus.connecting:
        return (AppColors.warning, Icons.wifi_rounded, 'Connecting...');
      case ConnectionStatus.disconnected:
        return (AppColors.warmGray400, Icons.wifi_off_rounded, 'Offline');
      case ConnectionStatus.error:
        return (AppColors.error, Icons.error_outline_rounded, 'Error');
    }
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  final bool isPulsing;

  const _PulsingDot({required this.color, this.isPulsing = false});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_PulsingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPulsing && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color.withValues(
              alpha: widget.isPulsing ? 0.4 + (_controller.value * 0.6) : 1.0,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
