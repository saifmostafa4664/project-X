import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/device/models/umbrella_state.dart';

void main() {
  group('UmbrellaDeviceState', () {
    test('initial factory has expected defaults', () {
      final state = UmbrellaDeviceState.initial();
      expect(state.umbrellaPosition, UmbrellaPosition.closed);
      expect(state.connectionStatus, ConnectionStatus.disconnected);
      expect(state.isSimulationMode, true);
      expect(state.battery, isA<BatteryState>());
      expect(state.lighting, isA<LightingState>());
      expect(state.sound, isA<SoundState>());
    });

    test('copyWith preserves unchanged fields', () {
      final state = UmbrellaDeviceState.initial();
      final updated = state.copyWith(
        umbrellaPosition: UmbrellaPosition.open,
      );

      expect(updated.umbrellaPosition, UmbrellaPosition.open);
      expect(updated.connectionStatus, state.connectionStatus);
      expect(updated.isSimulationMode, state.isSimulationMode);
    });

    test('copyWith replaces all provided fields', () {
      final now = DateTime(2026, 1, 1);
      final state = UmbrellaDeviceState(lastUpdated: now);
      final newBattery = const BatteryState(percentage: 42);
      final newLighting = const LightingState(isOn: true);
      final newSound = const SoundState(isPlaying: true);
      final later = DateTime(2026, 6, 1);

      final updated = state.copyWith(
        umbrellaPosition: UmbrellaPosition.opening,
        connectionStatus: ConnectionStatus.connected,
        battery: newBattery,
        lighting: newLighting,
        sound: newSound,
        lastUpdated: later,
        isSimulationMode: false,
      );

      expect(updated.umbrellaPosition, UmbrellaPosition.opening);
      expect(updated.connectionStatus, ConnectionStatus.connected);
      expect(updated.battery.percentage, 42);
      expect(updated.lighting.isOn, true);
      expect(updated.sound.isPlaying, true);
      expect(updated.lastUpdated, later);
      expect(updated.isSimulationMode, false);
    });

    test('isTransitioning returns true for opening/closing', () {
      final now = DateTime.now();
      final opening = UmbrellaDeviceState(
        umbrellaPosition: UmbrellaPosition.opening,
        lastUpdated: now,
      );
      final closing = UmbrellaDeviceState(
        umbrellaPosition: UmbrellaPosition.closing,
        lastUpdated: now,
      );
      final open = UmbrellaDeviceState(
        umbrellaPosition: UmbrellaPosition.open,
        lastUpdated: now,
      );
      final closed = UmbrellaDeviceState(
        umbrellaPosition: UmbrellaPosition.closed,
        lastUpdated: now,
      );

      expect(opening.isTransitioning, true);
      expect(closing.isTransitioning, true);
      expect(open.isTransitioning, false);
      expect(closed.isTransitioning, false);
    });

    test('isOperational returns true only when connected', () {
      final now = DateTime.now();
      final connected = UmbrellaDeviceState(
        connectionStatus: ConnectionStatus.connected,
        lastUpdated: now,
      );
      final disconnected = UmbrellaDeviceState(
        connectionStatus: ConnectionStatus.disconnected,
        lastUpdated: now,
      );
      final connecting = UmbrellaDeviceState(
        connectionStatus: ConnectionStatus.connecting,
        lastUpdated: now,
      );
      final error = UmbrellaDeviceState(
        connectionStatus: ConnectionStatus.error,
        lastUpdated: now,
      );

      expect(connected.isOperational, true);
      expect(disconnected.isOperational, false);
      expect(connecting.isOperational, false);
      expect(error.isOperational, false);
    });
  });

  group('BatteryState', () {
    test('default values', () {
      const battery = BatteryState();
      expect(battery.percentage, 75);
      expect(battery.chargingStatus, ChargingStatus.discharging);
      expect(battery.solarPowerWatts, 0.0);
      expect(battery.isSolarActive, false);
      expect(battery.minutesToFull, isNull);
      expect(battery.minutesRemaining, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      const battery = BatteryState(percentage: 50, isSolarActive: true);
      final updated = battery.copyWith(percentage: 80);

      expect(updated.percentage, 80);
      expect(updated.isSolarActive, true);
    });

    test('isLow returns true when percentage <= 20', () {
      expect(const BatteryState(percentage: 20).isLow, true);
      expect(const BatteryState(percentage: 10).isLow, true);
      expect(const BatteryState(percentage: 21).isLow, false);
    });

    test('isCritical returns true when percentage <= 10', () {
      expect(const BatteryState(percentage: 10).isCritical, true);
      expect(const BatteryState(percentage: 5).isCritical, true);
      expect(const BatteryState(percentage: 11).isCritical, false);
    });

    test('hasStrongSunlight returns true when solarPowerWatts > 30', () {
      expect(
        const BatteryState(solarPowerWatts: 31.0).hasStrongSunlight,
        true,
      );
      expect(
        const BatteryState(solarPowerWatts: 30.0).hasStrongSunlight,
        false,
      );
      expect(
        const BatteryState(solarPowerWatts: 29.9).hasStrongSunlight,
        false,
      );
    });

    test('boundary: percentage at 0 is both low and critical', () {
      const battery = BatteryState(percentage: 0);
      expect(battery.isLow, true);
      expect(battery.isCritical, true);
    });
  });

  group('LightingState', () {
    test('default values', () {
      const lighting = LightingState();
      expect(lighting.isOn, false);
      expect(lighting.color, const Color(0xFFFFFFFF));
      expect(lighting.brightness, 70);
      expect(lighting.mode, LightingMode.static);
    });

    test('copyWith works correctly', () {
      const lighting = LightingState();
      final updated = lighting.copyWith(
        isOn: true,
        color: const Color(0xFFFF0000),
        brightness: 50,
        mode: LightingMode.party,
      );

      expect(updated.isOn, true);
      expect(updated.color, const Color(0xFFFF0000));
      expect(updated.brightness, 50);
      expect(updated.mode, LightingMode.party);
    });

    test('effectiveColor is transparent when light is off', () {
      const lighting = LightingState(isOn: false, brightness: 100);
      expect(lighting.effectiveColor, const Color(0x00000000));
    });

    test('effectiveColor produces non-transparent color when on', () {
      const lighting = LightingState(
        isOn: true,
        color: Color(0xFFFF0000),
        brightness: 50,
      );
      final effective = lighting.effectiveColor;
      expect(effective.a, 1.0);
      expect(effective, isNot(equals(const Color(0x00000000))));
    });

    test('effectiveColor at full brightness returns non-black', () {
      const lighting = LightingState(
        isOn: true,
        color: Color(0xFF00FF00),
        brightness: 100,
      );
      final effective = lighting.effectiveColor;
      expect(effective.a, 1.0);
    });

    test('effectiveColor at zero brightness returns near-black', () {
      const lighting = LightingState(
        isOn: true,
        color: Color(0xFFFFFFFF),
        brightness: 0,
      );
      final effective = lighting.effectiveColor;
      expect(effective.r, closeTo(0.0, 0.01));
      expect(effective.g, closeTo(0.0, 0.01));
      expect(effective.b, closeTo(0.0, 0.01));
    });
  });

  group('SoundState', () {
    test('default values', () {
      const sound = SoundState();
      expect(sound.isPlaying, false);
      expect(sound.volume, 50);
      expect(sound.currentTrack, isNull);
      expect(sound.isAvailable, true);
    });

    test('copyWith works correctly', () {
      const sound = SoundState();
      final updated = sound.copyWith(
        isPlaying: true,
        volume: 80,
        currentTrack: 'Test Track',
        isAvailable: false,
      );

      expect(updated.isPlaying, true);
      expect(updated.volume, 80);
      expect(updated.currentTrack, 'Test Track');
      expect(updated.isAvailable, false);
    });

    test('copyWith preserves unchanged fields', () {
      const sound = SoundState(volume: 30, currentTrack: 'Song');
      final updated = sound.copyWith(isPlaying: true);

      expect(updated.volume, 30);
      expect(updated.currentTrack, 'Song');
    });
  });

  group('CompanionMessage', () {
    test('stores message, type, and timestamp', () {
      final now = DateTime(2026, 6, 15);
      final msg = CompanionMessage(
        message: 'Hello',
        type: CompanionMessageType.info,
        timestamp: now,
      );

      expect(msg.message, 'Hello');
      expect(msg.type, CompanionMessageType.info);
      expect(msg.timestamp, now);
    });
  });

  group('Enums', () {
    test('UmbrellaPosition has all expected values', () {
      expect(UmbrellaPosition.values.length, 4);
      expect(
        UmbrellaPosition.values,
        containsAll([
          UmbrellaPosition.open,
          UmbrellaPosition.closed,
          UmbrellaPosition.opening,
          UmbrellaPosition.closing,
        ]),
      );
    });

    test('ChargingStatus has all expected values', () {
      expect(ChargingStatus.values.length, 4);
    });

    test('LightingMode has all expected values', () {
      expect(LightingMode.values.length, 4);
      expect(
        LightingMode.values,
        containsAll([
          LightingMode.off,
          LightingMode.static,
          LightingMode.ambient,
          LightingMode.party,
        ]),
      );
    });

    test('ConnectionStatus has all expected values', () {
      expect(ConnectionStatus.values.length, 4);
    });

    test('CompanionMessageType has all expected values', () {
      expect(CompanionMessageType.values.length, 5);
    });
  });
}
