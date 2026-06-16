library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../device/umbrella_device_interface.dart';
import '../device/fake_umbrella_device.dart';
import '../device/esp32_umbrella_device.dart';
import '../device/models/umbrella_state.dart';

const _esp32IpKey = 'esp32_ip_address';
const _defaultEsp32Ip = '192.168.1.1';

final simulationModeProvider = StateProvider<bool>((ref) => true);

final esp32IpAddressProvider =
    StateNotifierProvider<Esp32IpNotifier, String>((ref) {
  return Esp32IpNotifier();
});

class Esp32IpNotifier extends StateNotifier<String> {
  Esp32IpNotifier() : super(_defaultEsp32Ip) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_esp32IpKey);
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  Future<void> setIp(String ip) async {
    state = ip;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_esp32IpKey, ip);
  }
}

final deviceProvider = Provider<UmbrellaDeviceInterface>((ref) {
  final isSimulation = ref.watch(simulationModeProvider);

  if (isSimulation) {
    final device = FakeUmbrellaDevice();
    ref.onDispose(() => device.dispose());
    return device;
  } else {
    final ip = ref.watch(esp32IpAddressProvider);
    final device = ESP32UmbrellaDevice(ipAddress: ip);
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
    // ignore: unnecessary_underscores
    error: (_, __) => ConnectionStatus.error,
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
