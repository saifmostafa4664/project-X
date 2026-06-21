library;

import 'package:flutter/material.dart';

enum UmbrellaPosition { open, closed, opening, closing }

enum ChargingStatus { charging, discharging, full, notConnected }

enum LightingMode { off, static, ambient, party }

enum ConnectionStatus { connected, connecting, disconnected, error }

class UmbrellaDeviceState {
  final UmbrellaPosition umbrellaPosition;

  final ConnectionStatus connectionStatus;

  final BatteryState battery;

  final LightingState lighting;

  final SoundState sound;

  final bool isLampOn;

  final bool isAromaOn;

  final DateTime lastUpdated;

  final bool isSimulationMode;

  const UmbrellaDeviceState({
    this.umbrellaPosition = UmbrellaPosition.closed,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.battery = const BatteryState(),
    this.lighting = const LightingState(),
    this.sound = const SoundState(),
    this.isLampOn = false,
    this.isAromaOn = false,
    required this.lastUpdated,
    this.isSimulationMode = true,
  });

  UmbrellaDeviceState copyWith({
    UmbrellaPosition? umbrellaPosition,
    ConnectionStatus? connectionStatus,
    BatteryState? battery,
    LightingState? lighting,
    SoundState? sound,
    bool? isLampOn,
    bool? isAromaOn,
    DateTime? lastUpdated,
    bool? isSimulationMode,
  }) {
    return UmbrellaDeviceState(
      umbrellaPosition: umbrellaPosition ?? this.umbrellaPosition,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      battery: battery ?? this.battery,
      lighting: lighting ?? this.lighting,
      sound: sound ?? this.sound,
      isLampOn: isLampOn ?? this.isLampOn,
      isAromaOn: isAromaOn ?? this.isAromaOn,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isSimulationMode: isSimulationMode ?? this.isSimulationMode,
    );
  }

  factory UmbrellaDeviceState.initial() {
    return UmbrellaDeviceState(lastUpdated: DateTime.now());
  }

  bool get isTransitioning =>
      umbrellaPosition == UmbrellaPosition.opening ||
      umbrellaPosition == UmbrellaPosition.closing;

  bool get isOperational => connectionStatus == ConnectionStatus.connected;
}

class BatteryState {
  final int percentage;

  final ChargingStatus chargingStatus;

  final double solarPowerWatts;

  final bool isSolarActive;

  final int? minutesToFull;

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

  bool get isLow => percentage <= 20;

  bool get isCritical => percentage <= 10;

  bool get hasStrongSunlight => solarPowerWatts > 30.0;
}

class LightingState {
  final bool isOn;

  final Color color;

  final int brightness;

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

class SoundState {
  final bool isPlaying;

  final int volume;

  final String? currentTrack;

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

enum CompanionMessageType { info, success, warning, error, tip }
