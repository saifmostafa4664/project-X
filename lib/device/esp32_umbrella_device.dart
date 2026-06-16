library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'umbrella_device_interface.dart';
import 'models/umbrella_state.dart';

class ESP32UmbrellaDevice extends UmbrellaDeviceInterface {
  final _stateController = StreamController<UmbrellaDeviceState>.broadcast();
  UmbrellaDeviceState _state = UmbrellaDeviceState.initial().copyWith(
    isSimulationMode: false,
  );

  final String ipAddress;
  final http.Client _httpClient;
  Timer? _pollTimer;

  static const _timeout = Duration(seconds: 5);
  static const _pollInterval = Duration(seconds: 3);

  ESP32UmbrellaDevice({required this.ipAddress, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  String get _baseUrl => 'http://$ipAddress';

  @override
  Stream<UmbrellaDeviceState> get stateStream => _stateController.stream;

  @override
  UmbrellaDeviceState get currentState => _state;

  @override
  bool get isSimulation => false;

  @override
  bool get isConnected =>
      _state.connectionStatus == ConnectionStatus.connected;

  void _updateState(UmbrellaDeviceState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  void _ensureConnected() {
    if (!isConnected) {
      throw const DeviceNotConnectedException();
    }
  }

  Future<bool> _sendGet(String path) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await _httpClient.get(uri).timeout(_timeout);
      return response.statusCode == 200;
    } on TimeoutException {
      throw const DeviceTimeoutException();
    } catch (e) {
      throw DeviceCommunicationException('HTTP request failed: $path', e);
    }
  }

  @override
  Future<bool> connect() async {
    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.connecting,
        lastUpdated: DateTime.now(),
      ),
    );

    try {
      final uri = Uri.parse(_baseUrl);
      final response = await _httpClient.get(uri).timeout(_timeout);
      final success = response.statusCode == 200 ||
          response.statusCode == 404;

      if (success) {
        _updateState(
          _state.copyWith(
            connectionStatus: ConnectionStatus.connected,
            lastUpdated: DateTime.now(),
          ),
        );
        _startPolling();
        return true;
      } else {
        _updateState(
          _state.copyWith(
            connectionStatus: ConnectionStatus.error,
            lastUpdated: DateTime.now(),
          ),
        );
        return false;
      }
    } catch (e) {
      _updateState(
        _state.copyWith(
          connectionStatus: ConnectionStatus.error,
          lastUpdated: DateTime.now(),
        ),
      );
      throw DeviceConnectionException(
        'Failed to connect to ESP32 at $ipAddress',
        e,
      );
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final uri = Uri.parse(_baseUrl);
      await _httpClient.get(uri).timeout(_timeout);
      if (!isConnected) {
        _updateState(
          _state.copyWith(
            connectionStatus: ConnectionStatus.connected,
            lastUpdated: DateTime.now(),
          ),
        );
      }
    } catch (_) {
      if (isConnected) {
        _updateState(
          _state.copyWith(
            connectionStatus: ConnectionStatus.disconnected,
            lastUpdated: DateTime.now(),
          ),
        );
      }
    }
  }

  @override
  Future<void> disconnect() async {
    _pollTimer?.cancel();
    _pollTimer = null;
    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.disconnected,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // --- Motor → Umbrella ---

  @override
  Future<void> openUmbrella() async {
    _ensureConnected();
    _updateState(
      _state.copyWith(
        umbrellaPosition: UmbrellaPosition.opening,
        lastUpdated: DateTime.now(),
      ),
    );
    final ok = await _sendGet('/motor?move=UP');
    if (ok) {
      _updateState(
        _state.copyWith(
          umbrellaPosition: UmbrellaPosition.open,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> closeUmbrella() async {
    _ensureConnected();
    _updateState(
      _state.copyWith(
        umbrellaPosition: UmbrellaPosition.closing,
        lastUpdated: DateTime.now(),
      ),
    );
    final ok = await _sendGet('/motor?move=DOWN');
    if (ok) {
      _updateState(
        _state.copyWith(
          umbrellaPosition: UmbrellaPosition.closed,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> stopUmbrella() async {
    _ensureConnected();
    final ok = await _sendGet('/motor?move=STOP');
    if (ok) {
      final pos = _state.umbrellaPosition == UmbrellaPosition.opening
          ? UmbrellaPosition.open
          : UmbrellaPosition.closed;
      _updateState(
        _state.copyWith(
          umbrellaPosition: pos,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  // --- LED ---

  @override
  Future<void> toggleLight(bool on) async {
    _ensureConnected();
    final ok = await _sendGet(on ? '/led/on' : '/led/off');
    if (ok) {
      _updateState(
        _state.copyWith(
          lighting: _state.lighting.copyWith(isOn: on),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> setRGBColor(Color color) async {
    _ensureConnected();
    // ESP32 does not have an RGB endpoint yet — store locally
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
    // ESP32 does not have a brightness endpoint yet — store locally
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
    if (mode == LightingMode.off) {
      await toggleLight(false);
    } else {
      await toggleLight(true);
    }
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

  // --- Sound ---

  @override
  Future<void> playMusic() async {
    _ensureConnected();
    final ok = await _sendGet('/sound/on');
    if (ok) {
      _updateState(
        _state.copyWith(
          sound: _state.sound.copyWith(
            isPlaying: true,
            currentTrack: 'ESP32 Audio',
          ),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> pauseMusic() async {
    _ensureConnected();
    final ok = await _sendGet('/sound/off');
    if (ok) {
      _updateState(
        _state.copyWith(
          sound: _state.sound.copyWith(isPlaying: false),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> setVolume(int level) async {
    _ensureConnected();
    // ESP32 does not have a volume endpoint yet — store locally
    _updateState(
      _state.copyWith(
        sound: _state.sound.copyWith(volume: level.clamp(0, 100)),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // --- Lamp (PIN_LAMB) ---

  Future<void> toggleLamp(bool on) async {
    _ensureConnected();
    await _sendGet(on ? '/lamb/on' : '/lamb/off');
  }

  // --- Aroma / Perfume ---

  Future<void> toggleAroma(bool on) async {
    _ensureConnected();
    await _sendGet(on ? '/aroma/on' : '/aroma/off');
  }

  // --- Status ---

  @override
  Future<UmbrellaDeviceState> getStatus() async {
    _ensureConnected();
    return _state;
  }

  @override
  Future<void> refreshState() async {
    if (isConnected) {
      await _checkConnection();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _httpClient.close();
    _stateController.close();
  }
}

enum CommunicationProtocol {
  ble,
  wifi,
  websocket,
}
