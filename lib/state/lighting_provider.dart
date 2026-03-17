/// Smart Umbrella App - Lighting Provider
///
/// Riverpod providers for RGB lighting control including
/// color selection, brightness, and lighting modes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import 'device_provider.dart';

/// Provider for current lighting state
final lightingStateProvider = Provider<LightingState>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.lighting,
    loading: () => const LightingState(),
    error: (_, __) => const LightingState(),
  );
});

/// Provider for light on/off status
final isLightOnProvider = Provider<bool>((ref) {
  return ref.watch(lightingStateProvider).isOn;
});

/// Provider for current light color
final lightColorProvider = Provider<Color>((ref) {
  return ref.watch(lightingStateProvider).color;
});

/// Provider for current brightness
final lightBrightnessProvider = Provider<int>((ref) {
  return ref.watch(lightingStateProvider).brightness;
});

/// Provider for current lighting mode
final lightingModeProvider = Provider<LightingMode>((ref) {
  return ref.watch(lightingStateProvider).mode;
});

/// Notifier for lighting control actions
class LightingControlNotifier extends AsyncNotifier<LightingState> {
  @override
  Future<LightingState> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.lighting;
  }

  /// Toggle lights on/off
  Future<void> toggle() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    final currentState = ref.read(lightingStateProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleLight(!currentState.isOn);
      state = AsyncValue.data(currentState.copyWith(isOn: !currentState.isOn));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Turn lights on
  Future<void> turnOn() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    state = const AsyncValue.loading();
    try {
      await device.toggleLight(true);
      final currentState = ref.read(lightingStateProvider);
      state = AsyncValue.data(currentState.copyWith(isOn: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Turn lights off
  Future<void> turnOff() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    state = const AsyncValue.loading();
    try {
      await device.toggleLight(false);
      final currentState = ref.read(lightingStateProvider);
      state = AsyncValue.data(currentState.copyWith(isOn: false));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Set RGB color
  Future<void> setColor(Color color) async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    try {
      await device.setRGBColor(color);
      final currentState = ref.read(lightingStateProvider);
      state = AsyncValue.data(currentState.copyWith(color: color));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Set brightness level (0-100)
  Future<void> setBrightness(int level) async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    try {
      await device.setBrightness(level);
      final currentState = ref.read(lightingStateProvider);
      state = AsyncValue.data(currentState.copyWith(brightness: level));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Set lighting mode
  Future<void> setMode(LightingMode mode) async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    state = const AsyncValue.loading();
    try {
      await device.setLightingMode(mode);
      final currentState = ref.read(lightingStateProvider);
      state = AsyncValue.data(
        currentState.copyWith(mode: mode, isOn: mode != LightingMode.off),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final lightingControlProvider =
    AsyncNotifierProvider<LightingControlNotifier, LightingState>(
      LightingControlNotifier.new,
    );

/// Preset colors for quick selection
final presetColorsProvider = Provider<List<Color>>((ref) {
  return [
    const Color(0xFFFFFFFF), // White
    const Color(0xFFFBBF24), // Warm yellow (sunset)
    const Color(0xFFF97316), // Orange
    const Color(0xFFEF4444), // Red
    const Color(0xFFEC4899), // Pink
    const Color(0xFFA855F7), // Purple
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFF10B981), // Green
  ];
});
