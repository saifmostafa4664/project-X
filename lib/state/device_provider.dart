library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/umbrella_device_interface.dart';
import '../device/fake_umbrella_device.dart';
import '../device/models/umbrella_state.dart';

final simulationModeProvider = StateProvider<bool>((ref) => true);

final deviceProvider = Provider<UmbrellaDeviceInterface>((ref) {
  final isSimulation = ref.watch(simulationModeProvider);

  if (isSimulation) {
    final device = FakeUmbrellaDevice();
    ref.onDispose(() => device.dispose());
    return device;
  } else {
    final device = FakeUmbrellaDevice();
    ref.onDispose(() => device.dispose());
    return device;
  }
});

final deviceStateStreamProvider = StreamProvider<UmbrellaDeviceState>((ref) {
  final device = ref.watch(deviceProvider);
  return device.stateStream;
});

final currentDeviceStateProvider = Provider<UmbrellaDeviceState>((ref) {
  final device = ref.watch(deviceProvider);
  return device.currentState;
});

final connectionStatusProvider = Provider<ConnectionStatus>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.connectionStatus,
    loading: () => ConnectionStatus.disconnected,
    error: (error, stackTrace) {
      debugPrint('Connection status stream error: $error');
      return ConnectionStatus.error;
    },
  );
});

final isConnectedProvider = Provider<bool>((ref) {
  final status = ref.watch(connectionStatusProvider);
  return status == ConnectionStatus.connected;
});

class DeviceConnectionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ref.read(deviceProvider).isConnected;
  }

  Future<void> connect() async {
    state = const AsyncValue.loading();
    try {
      final device = ref.read(deviceProvider);
      final success = await device.connect();
      state = AsyncValue.data(success);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> disconnect() async {
    state = const AsyncValue.loading();
    try {
      final device = ref.read(deviceProvider);
      await device.disconnect();
      state = const AsyncValue.data(false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final deviceConnectionProvider =
    AsyncNotifierProvider<DeviceConnectionNotifier, bool>(
      DeviceConnectionNotifier.new,
    );
