library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import 'device_provider.dart';

final lightingStateProvider = Provider<LightingState>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.lighting,
    loading: () => const LightingState(),
    // ignore: unnecessary_underscores
    error: (_, __) => const LightingState(),
  );
});

final isLightOnProvider = Provider<bool>((ref) {
  return ref.watch(lightingStateProvider).isOn;
});

final lightColorProvider = Provider<Color>((ref) {
  return ref.watch(lightingStateProvider).color;
});

final lightBrightnessProvider = Provider<int>((ref) {
  return ref.watch(lightingStateProvider).brightness;
});

final lightingModeProvider = Provider<LightingMode>((ref) {
  return ref.watch(lightingStateProvider).mode;
});

class LightingControlNotifier extends AsyncNotifier<LightingState> {
  @override
  Future<LightingState> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.lighting;
  }

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

final presetColorsProvider = Provider<List<Color>>((ref) {
  return [
    const Color(0xFFFFFFFF),
    const Color(0xFFFBBF24),
    const Color(0xFFF97316),
    const Color(0xFFEF4444),
    const Color(0xFFEC4899),
    const Color(0xFFA855F7),
    const Color(0xFF3B82F6),
    const Color(0xFF06B6D4),
    const Color(0xFF10B981),
  ];
});
