library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import 'device_provider.dart';

final soundStateProvider = Provider<SoundState>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.sound,
    loading: () => const SoundState(),
    // ignore: unnecessary_underscores
    error: (_, __) => const SoundState(),
  );
});

final isPlayingProvider = Provider<bool>((ref) {
  return ref.watch(soundStateProvider).isPlaying;
});

final volumeProvider = Provider<int>((ref) {
  return ref.watch(soundStateProvider).volume;
});

final currentTrackProvider = Provider<String?>((ref) {
  return ref.watch(soundStateProvider).currentTrack;
});

class SoundControlNotifier extends AsyncNotifier<SoundState> {
  @override
  Future<SoundState> build() async {
    final device = ref.read(deviceProvider);
    return device.currentState.sound;
  }

  Future<void> togglePlayback() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    final isPlaying = ref.read(isPlayingProvider);
    state = const AsyncValue.loading();
    try {
      if (isPlaying) {
        await device.pauseMusic();
      } else {
        await device.playMusic();
      }
      final currentState = ref.read(soundStateProvider);
      state = AsyncValue.data(currentState.copyWith(isPlaying: !isPlaying));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> play() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    state = const AsyncValue.loading();
    try {
      await device.playMusic();
      final currentState = ref.read(soundStateProvider);
      state = AsyncValue.data(currentState.copyWith(isPlaying: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> pause() async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    state = const AsyncValue.loading();
    try {
      await device.pauseMusic();
      final currentState = ref.read(soundStateProvider);
      state = AsyncValue.data(currentState.copyWith(isPlaying: false));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setVolume(int level) async {
    final device = ref.read(deviceProvider);
    if (!device.isConnected) return;

    try {
      await device.setVolume(level);
      final currentState = ref.read(soundStateProvider);
      state = AsyncValue.data(currentState.copyWith(volume: level));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final soundControlProvider =
    AsyncNotifierProvider<SoundControlNotifier, SoundState>(
      SoundControlNotifier.new,
    );
