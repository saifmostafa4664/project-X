library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'device_provider.dart';

/// Provider لحالة المبة (Lamp)
final isLampOnProvider = Provider<bool>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.isLampOn,
    loading: () => false,
    // ignore: unnecessary_underscores
    error: (_, __) => false,
  );
});

/// Provider لحالة العطر (Aroma/Perfume)
final isAromaOnProvider = Provider<bool>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.isAromaOn,
    loading: () => false,
    // ignore: unnecessary_underscores
    error: (_, __) => false,
  );
});

/// Notifier للتحكم في المبة
class LampControlNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.isLampOn;
  }

  Future<void> toggle() async {
    final device = ref.read(deviceProvider);
    final currentState = ref.read(isLampOnProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleLamp(!currentState);
      state = AsyncValue.data(!currentState);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> turnOn() async {
    final device = ref.read(deviceProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleLamp(true);
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> turnOff() async {
    final device = ref.read(deviceProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleLamp(false);
      state = const AsyncValue.data(false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final lampControlProvider = AsyncNotifierProvider<LampControlNotifier, bool>(
  LampControlNotifier.new,
);

/// Notifier للتحكم في العطر
class AromaControlNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.isAromaOn;
  }

  Future<void> toggle() async {
    final device = ref.read(deviceProvider);
    final currentState = ref.read(isAromaOnProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleAroma(!currentState);
      state = AsyncValue.data(!currentState);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> turnOn() async {
    final device = ref.read(deviceProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleAroma(true);
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> turnOff() async {
    final device = ref.read(deviceProvider);
    state = const AsyncValue.loading();
    try {
      await device.toggleAroma(false);
      state = const AsyncValue.data(false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final aromaControlProvider = AsyncNotifierProvider<AromaControlNotifier, bool>(
  AromaControlNotifier.new,
);
