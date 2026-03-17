/// Smart Umbrella App - Umbrella State Models
///
/// Immutable state models representing the complete state of the
/// smart umbrella device including umbrella position, battery status,
/// lighting configuration, and sound system state.
library;

import 'package:flutter/material.dart';

/// Represents the current position/state of the umbrella
enum UmbrellaPosition { open, closed, opening, closing }

/// Battery charging status
enum ChargingStatus { charging, discharging, full, notConnected }

/// RGB lighting mode
enum LightingMode { off, static, ambient, party }

/// Connection status to the physical device
enum ConnectionStatus { connected, connecting, disconnected, error }

/// Complete state of the umbrella device
/// Immutable class for predictable state management
class UmbrellaDeviceState {
  /// Umbrella physical position
  final UmbrellaPosition umbrellaPosition;

  /// Connection status to device
  final ConnectionStatus connectionStatus;

  /// Battery state information
  final BatteryState battery;

  /// RGB lighting state
  final LightingState lighting;

  /// Sound system state
  final SoundState sound;

  /// Last update timestamp
  final DateTime lastUpdated;

  /// Whether simulation mode is active
  final bool isSimulationMode;

  const UmbrellaDeviceState({
    this.umbrellaPosition = UmbrellaPosition.closed,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.battery = const BatteryState(),
    this.lighting = const LightingState(),
    this.sound = const SoundState(),
    required this.lastUpdated,
    this.isSimulationMode = true,
  });

  /// Creates a copy with modified fields
  UmbrellaDeviceState copyWith({
    UmbrellaPosition? umbrellaPosition,
    ConnectionStatus? connectionStatus,
    BatteryState? battery,
    LightingState? lighting,
    SoundState? sound,
    DateTime? lastUpdated,
    bool? isSimulationMode,
  }) {
    return UmbrellaDeviceState(
      umbrellaPosition: umbrellaPosition ?? this.umbrellaPosition,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      battery: battery ?? this.battery,
      lighting: lighting ?? this.lighting,
      sound: sound ?? this.sound,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isSimulationMode: isSimulationMode ?? this.isSimulationMode,
    );
  }

  /// Default initial state for the app
  factory UmbrellaDeviceState.initial() {
    return UmbrellaDeviceState(lastUpdated: DateTime.now());
  }

  /// Check if umbrella is in a transitional state
  bool get isTransitioning =>
      umbrellaPosition == UmbrellaPosition.opening ||
      umbrellaPosition == UmbrellaPosition.closing;

  /// Check if device is connected and operational
  bool get isOperational => connectionStatus == ConnectionStatus.connected;
}

/// Battery and solar panel state
class BatteryState {
  /// Current battery percentage (0-100)
  final int percentage;

  /// Current charging status
  final ChargingStatus chargingStatus;

  /// Solar panel power output in watts
  final double solarPowerWatts;

  /// Whether solar panel is actively charging
  final bool isSolarActive;

  /// Estimated time to full charge in minutes (null if not charging)
  final int? minutesToFull;

  /// Estimated remaining runtime in minutes (null if charging)
  final int? minutesRemaining;

  const BatteryState({
    this.percentage = 75,
    this.chargingStatus = ChargingStatus.discharging,
    this.solarPowerWatts = 0.0,
    this.isSolarActive = false,
    this.minutesToFull,
    this.minutesRemaining,
  });

  BatteryState copyWith({
    int? percentage,
    ChargingStatus? chargingStatus,
    double? solarPowerWatts,
    bool? isSolarActive,
    int? minutesToFull,
    int? minutesRemaining,
  }) {
    return BatteryState(
      percentage: percentage ?? this.percentage,
      chargingStatus: chargingStatus ?? this.chargingStatus,
      solarPowerWatts: solarPowerWatts ?? this.solarPowerWatts,
      isSolarActive: isSolarActive ?? this.isSolarActive,
      minutesToFull: minutesToFull ?? this.minutesToFull,
      minutesRemaining: minutesRemaining ?? this.minutesRemaining,
    );
  }

  /// Check if battery is low (<= 20%)
  bool get isLow => percentage <= 20;

  /// Check if battery is critical (<= 10%)
  bool get isCritical => percentage <= 10;

  /// Check if receiving strong sunlight (>30W)
  bool get hasStrongSunlight => solarPowerWatts > 30.0;
}

/// RGB lighting system state
class LightingState {
  /// Whether lights are on
  final bool isOn;

  /// Current RGB color
  final Color color;

  /// Brightness level (0-100)
  final int brightness;

  /// Current lighting mode
  final LightingMode mode;

  const LightingState({
    this.isOn = false,
    this.color = const Color(0xFFFFFFFF),
    this.brightness = 70,
    this.mode = LightingMode.static,
  });

  LightingState copyWith({
    bool? isOn,
    Color? color,
    int? brightness,
    LightingMode? mode,
  }) {
    return LightingState(
      isOn: isOn ?? this.isOn,
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      mode: mode ?? this.mode,
    );
  }

  /// Get color with brightness applied
  Color get effectiveColor {
    if (!isOn) return const Color(0x00000000);
    final factor = brightness / 100;
    return Color.fromRGBO(
      (color.r * factor).round(),
      (color.g * factor).round(),
      (color.b * factor).round(),
      1.0,
    );
  }
}

/// Sound system state
class SoundState {
  /// Whether music is currently playing
  final bool isPlaying;

  /// Current volume level (0-100)
  final int volume;

  /// Current track name (if available)
  final String? currentTrack;

  /// Whether sound system is available/connected
  final bool isAvailable;

  const SoundState({
    this.isPlaying = false,
    this.volume = 50,
    this.currentTrack,
    this.isAvailable = true,
  });

  SoundState copyWith({
    bool? isPlaying,
    int? volume,
    String? currentTrack,
    bool? isAvailable,
  }) {
    return SoundState(
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      currentTrack: currentTrack ?? this.currentTrack,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

/// Companion message for contextual user feedback
class CompanionMessage {
  final String message;
  final CompanionMessageType type;
  final DateTime timestamp;

  const CompanionMessage({
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

/// Types of companion messages
enum CompanionMessageType { info, success, warning, error, tip }
