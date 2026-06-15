library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'umbrella_device_interface.dart';
import 'models/umbrella_state.dart';

class ESP32UmbrellaDevice extends UmbrellaDeviceInterface {
  final _stateController = StreamController<UmbrellaDeviceState>.broadcast();
  final UmbrellaDeviceState _state = UmbrellaDeviceState.initial();

  ESP32UmbrellaDevice();

  @override
  Stream<UmbrellaDeviceState> get stateStream => _stateController.stream;

  @override
  UmbrellaDeviceState get currentState => _state;

  @override
  bool get isSimulation => false;

  @override
  bool get isConnected => _state.connectionStatus == ConnectionStatus.connected;

  @override
  Future<bool> connect() async {

    throw UnimplementedError(
      'ESP32 connection not yet implemented. Use FakeUmbrellaDevice for simulation.',
    );
  }

  @override
  Future<void> disconnect() async {
    throw UnimplementedError('ESP32 disconnection not yet implemented.');
  }

  @override
  Future<void> openUmbrella() async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> closeUmbrella() async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> stopUmbrella() async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> toggleLight(bool on) async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> setRGBColor(Color color) async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> setBrightness(int level) async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> setLightingMode(LightingMode mode) async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> playMusic() async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> pauseMusic() async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<void> setVolume(int level) async {
    throw UnimplementedError('ESP32 commands not yet implemented.');
  }

  @override
  Future<UmbrellaDeviceState> getStatus() async {
    throw UnimplementedError('ESP32 status not yet implemented.');
  }

  @override
  Future<void> refreshState() async {
    throw UnimplementedError('ESP32 refresh not yet implemented.');
  }

  @override
  void dispose() {
    _stateController.close();
  }

}

enum CommunicationProtocol {
  ble,

  wifi,

  websocket,
}
