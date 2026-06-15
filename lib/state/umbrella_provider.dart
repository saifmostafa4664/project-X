library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import 'device_provider.dart';

final umbrellaPositionProvider = Provider<UmbrellaPosition>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.umbrellaPosition,
    loading: () => UmbrellaPosition.closed,
    // ignore: unnecessary_underscores
    error: (_, __) => UmbrellaPosition.closed,
  );
});

final isUmbrellaTransitioningProvider = Provider<bool>((ref) {
  final position = ref.watch(umbrellaPositionProvider);
  return position == UmbrellaPosition.opening ||
      position == UmbrellaPosition.closing;
});

class UmbrellaControlNotifier extends AsyncNotifier<UmbrellaPosition> {
  @override
  Future<UmbrellaPosition> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.umbrellaPosition;
  }

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

  Future<void> toggle() async {
    final currentPosition = ref.read(umbrellaPositionProvider);
    if (currentPosition == UmbrellaPosition.open) {
      await close();
    } else if (currentPosition == UmbrellaPosition.closed) {
      await open();
    }
  }

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
