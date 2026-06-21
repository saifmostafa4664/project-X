library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'umbrella_device_interface.dart';
import 'models/umbrella_state.dart';

class ESP32UmbrellaDevice extends UmbrellaDeviceInterface {
  final _stateController = StreamController<UmbrellaDeviceState>.broadcast();
  UmbrellaDeviceState _state = UmbrellaDeviceState.initial();

  static const String _baseUrl = 'http://192.168.4.1';

  static const Duration _timeout = Duration(seconds: 5);

  ESP32UmbrellaDevice();

  @override
  Stream<UmbrellaDeviceState> get stateStream => _stateController.stream;

  @override
  UmbrellaDeviceState get currentState => _state;

  @override
  bool get isSimulation => false;

  @override
  bool get isConnected => _state.connectionStatus == ConnectionStatus.connected;

  /// بيبعت HTTP GET request للـ ESP32
  Future<bool> _sendCommand(String endpoint) async {
    try {
      debugPrint('ESP32 sending: $_baseUrl$endpoint');
      final response = await http
          .get(Uri.parse('$_baseUrl$endpoint'))
          .timeout(_timeout);
      debugPrint('ESP32 response: ${response.statusCode} - ${response.body}');

      // لو نجح الريكويست ومكناش connected، نعمل auto-connect
      if (response.statusCode == 200 &&
          _state.connectionStatus != ConnectionStatus.connected) {
        _updateState(
          _state.copyWith(
            connectionStatus: ConnectionStatus.connected,
            lastUpdated: DateTime.now(),
            isSimulationMode: false,
          ),
        );
      }

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('ESP32 command failed: $endpoint - $e');
      return false;
    }
  }

  @override
  Future<bool> connect() async {
    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.connecting,
        lastUpdated: DateTime.now(),
        isSimulationMode: false,
      ),
    );

    // نحاول نتواصل مع الـ ESP32 عشان نتأكد إنه شغال
    final success = await _sendCommand('/led/off');
    if (success) {
      _updateState(
        _state.copyWith(
          connectionStatus: ConnectionStatus.connected,
          lastUpdated: DateTime.now(),
        ),
      );
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
  }

  @override
  Future<void> disconnect() async {
    await _sendCommand('/led/off');
    await _sendCommand('/lamb/off');
    await _sendCommand('/sound/off');
    await _sendCommand('/aroma/off');
    await _sendCommand('/motor?move=STOP');

    _updateState(
      _state.copyWith(
        connectionStatus: ConnectionStatus.disconnected,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> openUmbrella() async {
    final success = await _sendCommand('/motor?move=UP');
    if (success) {
      _updateState(
        _state.copyWith(
          umbrellaPosition: UmbrellaPosition.opening,
          lastUpdated: DateTime.now(),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        _updateState(
          _state.copyWith(
            umbrellaPosition: UmbrellaPosition.open,
            lastUpdated: DateTime.now(),
          ),
        );
      });
    }
  }

  @override
  Future<void> closeUmbrella() async {
    final success = await _sendCommand('/motor?move=DOWN');
    if (success) {
      _updateState(
        _state.copyWith(
          umbrellaPosition: UmbrellaPosition.closing,
          lastUpdated: DateTime.now(),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        _updateState(
          _state.copyWith(
            umbrellaPosition: UmbrellaPosition.closed,
            lastUpdated: DateTime.now(),
          ),
        );
      });
    }
  }

  @override
  Future<void> stopUmbrella() async {
    final success = await _sendCommand('/motor?move=STOP');
    if (success) {
      _updateState(
        _state.copyWith(
          umbrellaPosition: _state.umbrellaPosition == UmbrellaPosition.opening
              ? UmbrellaPosition.open
              : UmbrellaPosition.closed,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> toggleLight(bool on) async {
    final endpoint = on ? '/led/on' : '/led/off';
    final success = await _sendCommand(endpoint);
    if (success) {
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
    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(color: color),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setBrightness(int level) async {
    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(brightness: level.clamp(0, 100)),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setLightingMode(LightingMode mode) async {
    final isOn = mode != LightingMode.off;
    await toggleLight(isOn);
    _updateState(
      _state.copyWith(
        lighting: _state.lighting.copyWith(mode: mode, isOn: isOn),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> toggleLamp(bool on) async {
    final endpoint = on ? '/lamb/on' : '/lamb/off';
    final success = await _sendCommand(endpoint);
    if (success) {
      _updateState(_state.copyWith(isLampOn: on, lastUpdated: DateTime.now()));
    }
  }

  @override
  Future<void> toggleAroma(bool on) async {
    final endpoint = on ? '/aroma/on' : '/aroma/off';
    final success = await _sendCommand(endpoint);
    if (success) {
      _updateState(_state.copyWith(isAromaOn: on, lastUpdated: DateTime.now()));
    }
  }

  @override
  Future<void> playMusic() async {
    final success = await _sendCommand('/sound/on');
    if (success) {
      _updateState(
        _state.copyWith(
          sound: _state.sound.copyWith(
            isPlaying: true,
            currentTrack: 'ESP32 Sound',
          ),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> pauseMusic() async {
    final success = await _sendCommand('/sound/off');
    if (success) {
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
    _updateState(
      _state.copyWith(
        sound: _state.sound.copyWith(volume: level.clamp(0, 100)),
        lastUpdated: DateTime.now(),
      ),
    );
  }

  @override
  Future<UmbrellaDeviceState> getStatus() async {
    return _state;
  }

  @override
  Future<void> refreshState() async {
    _updateState(_state.copyWith(lastUpdated: DateTime.now()));
  }

  @override
  void dispose() {
    _stateController.close();
  }

  void _updateState(UmbrellaDeviceState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }
}

enum CommunicationProtocol { ble, wifi, websocket }
