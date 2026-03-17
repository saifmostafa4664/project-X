/// Smart Umbrella App - Umbrella Control Provider
///
/// Riverpod providers for umbrella open/close control with
/// loading states and error handling.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import 'device_provider.dart';

/// Provider for umbrella position
final umbrellaPositionProvider = Provider<UmbrellaPosition>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.umbrellaPosition,
    loading: () => UmbrellaPosition.closed,
    error: (_, __) => UmbrellaPosition.closed,
  );
});

/// Provider to check if umbrella is transitioning
final isUmbrellaTransitioningProvider = Provider<bool>((ref) {
  final position = ref.watch(umbrellaPositionProvider);
  return position == UmbrellaPosition.opening ||
      position == UmbrellaPosition.closing;
});

/// Notifier for umbrella control actions
class UmbrellaControlNotifier extends AsyncNotifier<UmbrellaPosition> {
  @override
  Future<UmbrellaPosition> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.umbrellaPosition;
  }

  /// Open the umbrella
  Future<void> open() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) {
      state = AsyncValue.error('Device not connected', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      await device.openUmbrella();
      state = const AsyncValue.data(UmbrellaPosition.open);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Close the umbrella
  Future<void> close() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) {
      state = AsyncValue.error('Device not connected', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      await device.closeUmbrella();
      state = const AsyncValue.data(UmbrellaPosition.closed);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggle umbrella state
  Future<void> toggle() async {
    final currentPosition = ref.read(umbrellaPositionProvider);
    if (currentPosition == UmbrellaPosition.open) {
      await close();
    } else if (currentPosition == UmbrellaPosition.closed) {
      await open();
    }
    // Ignore toggle during transition
  }

  /// Stop umbrella movement
  Future<void> stop() async {
    final device = ref.read(deviceProvider);
    try {
      await device.stopUmbrella();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final umbrellaControlProvider =
    AsyncNotifierProvider<UmbrellaControlNotifier, UmbrellaPosition>(
      UmbrellaControlNotifier.new,
    );
