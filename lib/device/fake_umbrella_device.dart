library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'umbrella_device_interface.dart';
import 'models/umbrella_state.dart';

class FakeUmbrellaDevice extends UmbrellaDeviceInterface {
  final _stateController = StreamController<UmbrellaDeviceState>.broadcast();

  UmbrellaDeviceState _state = UmbrellaDeviceState.initial();

  Timer? _simulationTimer;

  final _random = Random();

  bool _forceDisconnected = false;
  bool _forceLowBattery = false;
  bool _forceStrongSunlight = false;

  FakeUmbrellaDevice() {
    _startSimulation();
  }

  @override
  Stream<UmbrellaDeviceState> get stateStream => _stateController.stream;

  @override
  UmbrellaDeviceState get currentState => _state;

  @override
  bool get isSimulation => true;

  @override
  bool get isConnected =>
      _state.connectionStatus == ConnectionStatus.connected &&
      !_forceDisconnected;

  @override
  Future<bool> connect() async {
    if (_forceDisconnected) {
      _updateState(
        _state.copyWith(
          connectionStatus: ConnectionStatus.error,
          lastUpdated: DateTime.now(),
        ),
      );
      throw const DeviceConnectionException('Simulated connection failure');
    }

    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.connecting,
        lastUpdated: DateTime.now(),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.connected,
        lastUpdated: DateTime.now(),
      ),
    );

    return true;
  }

  @override
  Future<void> disconnect() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.disconnected,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> openUmbrella() async {
    _ensureConnected();

    if (_state.umbrellaPosition == UmbrellaPosition.open) {
      return;
    }

    _updateState(
      _state.copyWith(
        umbrellaPosition: UmbrellaPosition.opening,
        lastUpdated: DateTime.now(),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 2000));

    _updateState(
      _state.copyWith(
        umbrellaPosition: UmbrellaPosition.open,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> closeUmbrella() async {
    _ensureConnected();

    if (_state.umbrellaPosition == UmbrellaPosition.closed) {
      return;
    }

    _updateState(
      _state.copyWith(
        umbrellaPosition: UmbrellaPosition.closing,
        lastUpdated: DateTime.now(),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 2000));

    _updateState(
      _state.copyWith(
        umbrellaPosition: UmbrellaPosition.closed,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> stopUmbrella() async {
    _ensureConnected();

    if (_state.isTransitioning) {
      final newPosition = _state.umbrellaPosition == UmbrellaPosition.opening
          ? UmbrellaPosition.open
          : UmbrellaPosition.closed;

      _updateState(
        _state.copyWith(
          umbrellaPosition: newPosition,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> toggleLight(bool on) async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(isOn: on),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setRGBColor(Color color) async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(color: color),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setBrightness(int level) async {
    _ensureConnected();
    final clampedLevel = level.clamp(0, 100);
    await Future.delayed(const Duration(milliseconds: 50));

    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(brightness: clampedLevel),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setLightingMode(LightingMode mode) async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(
          mode: mode,
          isOn: mode != LightingMode.off,
        ),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> toggleLamp(bool on) async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        isLampOn: on,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> toggleAroma(bool on) async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        isAromaOn: on,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> playMusic() async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        sound: _state.sound.copyWith(
          isPlaying: true,
          currentTrack: 'Beach Vibes Mix',
        ),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> pauseMusic() async {
    _ensureConnected();
    await Future.delayed(const Duration(milliseconds: 100));

    _updateState(
      _state.copyWith(
        sound: _state.sound.copyWith(isPlaying: false),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setVolume(int level) async {
    _ensureConnected();
    final clampedLevel = level.clamp(0, 100);
    await Future.delayed(const Duration(milliseconds: 50));

    _updateState(
      _state.copyWith(
        sound: _state.sound.copyWith(volume: clampedLevel),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<UmbrellaDeviceState> getStatus() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _state;
  }

  @override
  Future<void> refreshState() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updateState(_state.copyWith(lastUpdated: DateTime.now()));
  }

  void forceDisconnected(bool force) {
    _forceDisconnected = force;
    if (force && isConnected) {
      _updateState(
        _state.copyWith(
          connectionStatus: ConnectionStatus.disconnected,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void forceLowBattery(bool force) {
    _forceLowBattery = force;
    if (force) {
      _updateState(
        _state.copyWith(
          battery: _state.battery.copyWith(
            percentage: 15,
            chargingStatus: ChargingStatus.discharging,
          ),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void forceStrongSunlight(bool force) {
    _forceStrongSunlight = force;
    if (force) {
      _updateState(
        _state.copyWith(
          battery: _state.battery.copyWith(
            solarPowerWatts: 45.0,
            isSolarActive: true,
            chargingStatus: ChargingStatus.charging,
          ),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  Map<String, bool> get debugFlags => {
    'forceDisconnected': _forceDisconnected,
    'forceLowBattery': _forceLowBattery,
    'forceStrongSunlight': _forceStrongSunlight,
  };

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _stateController.close();
  }

  void _ensureConnected() {
    if (!isConnected) {
      throw const DeviceNotConnectedException();
    }
  }

  void _updateState(UmbrellaDeviceState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _simulateRealTimeChanges(),
    );
  }

  void _simulateRealTimeChanges() {
    if (!isConnected) return;

    if (_forceLowBattery || _forceStrongSunlight) return;

    var battery = _state.battery;

    final solarBase = _random.nextDouble() * 50;
    final solarPower =
        solarBase + (_random.nextDouble() * 10 - 5);
    final isSolarActive = solarPower > 10;

    int batteryChange = 0;
    ChargingStatus chargingStatus;

    if (solarPower > 20) {
      chargingStatus = ChargingStatus.charging;
      batteryChange = 1;
    } else if (_state.lighting.isOn || _state.sound.isPlaying) {
      chargingStatus = ChargingStatus.discharging;
      batteryChange = -1;
    } else {
      chargingStatus = ChargingStatus.discharging;
      batteryChange = _random.nextBool() ? 0 : -1;
    }

    final newPercentage = (battery.percentage + batteryChange).clamp(0, 100);

    if (newPercentage == 100) {
      chargingStatus = ChargingStatus.full;
    }

    _updateState(
      _state.copyWith(
        battery: battery.copyWith(
          percentage: newPercentage,
          solarPowerWatts: solarPower.clamp(0, 60),
          isSolarActive: isSolarActive,
          chargingStatus: chargingStatus,
          minutesToFull: chargingStatus == ChargingStatus.charging
              ? ((100 - newPercentage) * 2)
              : null,
          minutesRemaining: chargingStatus == ChargingStatus.discharging
              ? (newPercentage * 3)
              : null,
        ),
        lastUpdated: DateTime.now(),
      ),
    );
  }
}
