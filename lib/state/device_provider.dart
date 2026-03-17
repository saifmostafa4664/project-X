/// Smart Umbrella App - Device Provider
///
/// Main Riverpod provider managing the umbrella device instance,
/// simulation mode toggle, and device state stream.
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/umbrella_device_interface.dart';
import '../device/fake_umbrella_device.dart';
import '../device/models/umbrella_state.dart';

/// Provider for simulation mode toggle
final simulationModeProvider = StateProvider<bool>((ref) => true);

/// Provider for the device interface instance
///
/// This is the main entry point for device communication.
/// In simulation mode, returns FakeUmbrellaDevice.
/// In production, would return ESP32UmbrellaDevice.
final deviceProvider = Provider<UmbrellaDeviceInterface>((ref) {
  final isSimulation = ref.watch(simulationModeProvider);

  if (isSimulation) {
    final device = FakeUmbrellaDevice();
    ref.onDispose(() => device.dispose());
    return device;
  } else {
    // TODO: Return ESP32UmbrellaDevice when hardware is ready
    // For now, always use fake device
    final device = FakeUmbrellaDevice();
    ref.onDispose(() => device.dispose());
    return device;
  }
});

/// Provider for the device state stream
final deviceStateStreamProvider = StreamProvider<UmbrellaDeviceState>((ref) {
  final device = ref.watch(deviceProvider);
  return device.stateStream;
});

/// Provider for the current device state (synchronous)
final currentDeviceStateProvider = Provider<UmbrellaDeviceState>((ref) {
  final device = ref.watch(deviceProvider);
  return device.currentState;
});

/// Provider for connection status
final connectionStatusProvider = Provider<ConnectionStatus>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.connectionStatus,
    loading: () => ConnectionStatus.disconnected,
    error: (_, __) => ConnectionStatus.error,
  );
});

/// Provider to check if device is connected
final isConnectedProvider = Provider<bool>((ref) {
  final status = ref.watch(connectionStatusProvider);
  return status == ConnectionStatus.connected;
});

/// Notifier for managing device connection
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
