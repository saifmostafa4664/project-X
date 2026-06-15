library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'models/umbrella_state.dart';

abstract class UmbrellaDeviceInterface {
  Stream<UmbrellaDeviceState> get stateStream;

  UmbrellaDeviceState get currentState;

  bool get isSimulation;

  Future<bool> connect();

  Future<void> disconnect();

  bool get isConnected;

  Future<void> openUmbrella();

  Future<void> closeUmbrella();

  Future<void> stopUmbrella();

  Future<void> toggleLight(bool on);

  Future<void> setRGBColor(Color color);

  Future<void> setBrightness(int level);

  Future<void> setLightingMode(LightingMode mode);

  Future<void> playMusic();

  Future<void> pauseMusic();

  Future<void> setVolume(int level);

  Future<UmbrellaDeviceState> getStatus();

  Future<void> refreshState();

  void dispose();
}

abstract class DeviceException implements Exception {
  final String message;
  final dynamic originalError;

  const DeviceException(this.message, [this.originalError]);

  @override
  String toString() => '$runtimeType: $message';
}

class DeviceNotConnectedException extends DeviceException {
  const DeviceNotConnectedException([super.message = 'Device not connected']);
}

class DeviceConnectionException extends DeviceException {
  const DeviceConnectionException(super.message, [super.originalError]);
}

class UmbrellaOperationException extends DeviceException {
  const UmbrellaOperationException(super.message, [super.originalError]);
}

class DeviceTimeoutException extends DeviceException {
  const DeviceTimeoutException([super.message = 'Operation timed out']);
}

class DeviceCommunicationException extends DeviceException {
  const DeviceCommunicationException(super.message, [super.originalError]);
}
