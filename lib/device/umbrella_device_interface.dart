/// Smart Umbrella App - Device Interface
///
/// Abstract interface defining all commands and queries for controlling
/// the smart umbrella device. This interface allows the app to be
/// hardware-agnostic - implementations can be swapped without changing
/// the app code.
///
/// Implementations:
/// - FakeUmbrellaDevice: Simulation mode for development
/// - ESP32UmbrellaDevice: Real hardware connection (placeholder)
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'models/umbrella_state.dart';

/// Abstract interface for umbrella device communication
///
/// All device implementations must extend this class.
/// The interface supports both command execution and state streaming.
abstract class UmbrellaDeviceInterface {
  /// Stream of device state updates
  ///
  /// Implementations should emit new states whenever the device
  /// state changes (either from commands or external factors).
  Stream<UmbrellaDeviceState> get stateStream;

  /// Current device state (synchronous access)
  UmbrellaDeviceState get currentState;

  /// Whether this is a simulation implementation
  bool get isSimulation;

  // ============================================================
  // CONNECTION MANAGEMENT
  // ============================================================

  /// Connect to the umbrella device
  ///
  /// Returns true if connection was successful.
  /// May throw [DeviceConnectionException] on failure.
  Future<bool> connect();

  /// Disconnect from the umbrella device
  Future<void> disconnect();

  /// Check if currently connected
  bool get isConnected;

  // ============================================================
  // UMBRELLA CONTROL
  // ============================================================

  /// Open the umbrella
  ///
  /// The umbrella will transition from closed -> opening -> open.
  /// Throws [DeviceNotConnectedException] if not connected.
  /// Throws [UmbrellaOperationException] if operation fails.
  Future<void> openUmbrella();

  /// Close the umbrella
  ///
  /// The umbrella will transition from open -> closing -> closed.
  /// Throws [DeviceNotConnectedException] if not connected.
  /// Throws [UmbrellaOperationException] if operation fails.
  Future<void> closeUmbrella();

  /// Stop any ongoing umbrella movement
  Future<void> stopUmbrella();

  // ============================================================
  // RGB LIGHTING CONTROL
  // ============================================================

  /// Turn lights on or off
  Future<void> toggleLight(bool on);

  /// Set the RGB color of the lights
  ///
  /// [color] - The desired color
  Future<void> setRGBColor(Color color);

  /// Set brightness level
  ///
  /// [level] - Brightness from 0 to 100
  Future<void> setBrightness(int level);

  /// Set lighting mode
  ///
  /// [mode] - The desired lighting mode (static, ambient, party)
  Future<void> setLightingMode(LightingMode mode);

  // ============================================================
  // SOUND SYSTEM CONTROL
  // ============================================================

  /// Start playing music
  Future<void> playMusic();

  /// Pause music playback
  Future<void> pauseMusic();

  /// Set volume level
  ///
  /// [level] - Volume from 0 to 100
  Future<void> setVolume(int level);

  // ============================================================
  // STATUS & MONITORING
  // ============================================================

  /// Get current complete device status
  ///
  /// Refreshes and returns the current state from the device.
  Future<UmbrellaDeviceState> getStatus();

  /// Force refresh state from device
  Future<void> refreshState();

  // ============================================================
  // LIFECYCLE
  // ============================================================

  /// Dispose of resources
  ///
  /// Call this when the device interface is no longer needed.
  void dispose();
}

/// Base exception for device-related errors
abstract class DeviceException implements Exception {
  final String message;
  final dynamic originalError;

  const DeviceException(this.message, [this.originalError]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when device is not connected but connection is required
class DeviceNotConnectedException extends DeviceException {
  const DeviceNotConnectedException([super.message = 'Device not connected']);
}

/// Thrown when connection to device fails
class DeviceConnectionException extends DeviceException {
  const DeviceConnectionException(super.message, [super.originalError]);
}

/// Thrown when an umbrella operation fails
class UmbrellaOperationException extends DeviceException {
  const UmbrellaOperationException(super.message, [super.originalError]);
}

/// Thrown when a command times out
class DeviceTimeoutException extends DeviceException {
  const DeviceTimeoutException([super.message = 'Operation timed out']);
}

/// Thrown when communication with device fails
class DeviceCommunicationException extends DeviceException {
  const DeviceCommunicationException(super.message, [super.originalError]);
}
