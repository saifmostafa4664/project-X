import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/device/fake_umbrella_device.dart';
import 'package:usmart/device/models/umbrella_state.dart';
import 'package:usmart/device/umbrella_device_interface.dart';

void main() {
  late FakeUmbrellaDevice device;

  setUp(() {
    device = FakeUmbrellaDevice();
  });

  tearDown(() {
    device.dispose();
  });

  group('FakeUmbrellaDevice - basic properties', () {
    test('isSimulation returns true', () {
      expect(device.isSimulation, true);
    });

    test('initial state is disconnected and closed', () {
      expect(device.currentState.connectionStatus,
          ConnectionStatus.disconnected);
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.closed);
    });

    test('isConnected is false initially', () {
      expect(device.isConnected, false);
    });
  });

  group('FakeUmbrellaDevice - connect/disconnect', () {
    test('connect transitions to connected', () async {
      await device.connect();
      expect(device.isConnected, true);
      expect(device.currentState.connectionStatus,
          ConnectionStatus.connected);
    });

    test('disconnect transitions to disconnected', () async {
      await device.connect();
      await device.disconnect();
      expect(device.isConnected, false);
      expect(device.currentState.connectionStatus,
          ConnectionStatus.disconnected);
    });

    test('connect emits connecting then connected states', () async {
      final states = <ConnectionStatus>[];
      final sub = device.stateStream.listen(
        (s) => states.add(s.connectionStatus),
      );

      await device.connect();
      // Allow stream events to propagate
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();

      expect(states, contains(ConnectionStatus.connecting));
      expect(states, contains(ConnectionStatus.connected));
    });

    test('connect throws when forceDisconnected is set', () async {
      device.forceDisconnected(true);
      expect(
        () => device.connect(),
        throwsA(isA<DeviceConnectionException>()),
      );
    });
  });

  group('FakeUmbrellaDevice - umbrella operations', () {
    setUp(() async {
      await device.connect();
    });

    test('openUmbrella transitions to open', () async {
      await device.openUmbrella();
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.open);
    });

    test('closeUmbrella transitions to closed', () async {
      await device.openUmbrella();
      await device.closeUmbrella();
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.closed);
    });

    test('openUmbrella is idempotent when already open', () async {
      await device.openUmbrella();
      await device.openUmbrella();
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.open);
    });

    test('closeUmbrella is idempotent when already closed', () async {
      await device.closeUmbrella();
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.closed);
    });

    test('stopUmbrella resolves opening to open', () async {
      // We need to start opening and then immediately stop.
      // Since openUmbrella awaits, we fire-and-forget and call stop quickly.
      final openFuture = device.openUmbrella();
      // The state should be opening during the delay
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.opening);
      await device.stopUmbrella();
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.open);
      await openFuture;
    });

    test('umbrella operations throw when disconnected', () async {
      await device.disconnect();
      expect(
        () => device.openUmbrella(),
        throwsA(isA<DeviceNotConnectedException>()),
      );
      expect(
        () => device.closeUmbrella(),
        throwsA(isA<DeviceNotConnectedException>()),
      );
    });
  });

  group('FakeUmbrellaDevice - lighting', () {
    setUp(() async {
      await device.connect();
    });

    test('toggleLight turns light on and off', () async {
      await device.toggleLight(true);
      expect(device.currentState.lighting.isOn, true);

      await device.toggleLight(false);
      expect(device.currentState.lighting.isOn, false);
    });

    test('setRGBColor updates color', () async {
      await device.setRGBColor(const Color(0xFFFF0000));
      expect(device.currentState.lighting.color, const Color(0xFFFF0000));
    });

    test('setBrightness clamps to 0-100', () async {
      await device.setBrightness(150);
      expect(device.currentState.lighting.brightness, 100);

      await device.setBrightness(-10);
      expect(device.currentState.lighting.brightness, 0);

      await device.setBrightness(50);
      expect(device.currentState.lighting.brightness, 50);
    });

    test('setLightingMode updates mode and toggles isOn', () async {
      await device.setLightingMode(LightingMode.party);
      expect(device.currentState.lighting.mode, LightingMode.party);
      expect(device.currentState.lighting.isOn, true);

      await device.setLightingMode(LightingMode.off);
      expect(device.currentState.lighting.mode, LightingMode.off);
      expect(device.currentState.lighting.isOn, false);
    });

    test('lighting operations throw when disconnected', () async {
      await device.disconnect();
      expect(
        () => device.toggleLight(true),
        throwsA(isA<DeviceNotConnectedException>()),
      );
    });
  });

  group('FakeUmbrellaDevice - sound', () {
    setUp(() async {
      await device.connect();
    });

    test('playMusic sets isPlaying and sets track', () async {
      await device.playMusic();
      expect(device.currentState.sound.isPlaying, true);
      expect(device.currentState.sound.currentTrack, 'Beach Vibes Mix');
    });

    test('pauseMusic sets isPlaying to false', () async {
      await device.playMusic();
      await device.pauseMusic();
      expect(device.currentState.sound.isPlaying, false);
    });

    test('setVolume clamps to 0-100', () async {
      await device.setVolume(120);
      expect(device.currentState.sound.volume, 100);

      await device.setVolume(-5);
      expect(device.currentState.sound.volume, 0);

      await device.setVolume(75);
      expect(device.currentState.sound.volume, 75);
    });

    test('sound operations throw when disconnected', () async {
      await device.disconnect();
      expect(
        () => device.playMusic(),
        throwsA(isA<DeviceNotConnectedException>()),
      );
    });
  });

  group('FakeUmbrellaDevice - status and refresh', () {
    test('getStatus returns current state', () async {
      final status = await device.getStatus();
      expect(status.connectionStatus, device.currentState.connectionStatus);
    });

    test('refreshState updates lastUpdated', () async {
      final before = device.currentState.lastUpdated;
      await Future.delayed(const Duration(milliseconds: 10));
      await device.refreshState();
      expect(
        device.currentState.lastUpdated.isAfter(before),
        true,
      );
    });
  });

  group('FakeUmbrellaDevice - debug flags', () {
    test('forceLowBattery sets battery to 15%', () {
      device.forceLowBattery(true);
      expect(device.currentState.battery.percentage, 15);
      expect(device.currentState.battery.isLow, true);
      expect(
        device.currentState.battery.chargingStatus,
        ChargingStatus.discharging,
      );
    });

    test('forceStrongSunlight sets solar power and charging', () {
      device.forceStrongSunlight(true);
      expect(device.currentState.battery.solarPowerWatts, 45.0);
      expect(device.currentState.battery.isSolarActive, true);
      expect(device.currentState.battery.hasStrongSunlight, true);
      expect(
        device.currentState.battery.chargingStatus,
        ChargingStatus.charging,
      );
    });

    test('forceDisconnected disconnects the device', () async {
      await device.connect();
      expect(device.isConnected, true);

      device.forceDisconnected(true);
      expect(device.isConnected, false);
    });

    test('debugFlags returns current flag states', () {
      expect(device.debugFlags['forceDisconnected'], false);
      expect(device.debugFlags['forceLowBattery'], false);
      expect(device.debugFlags['forceStrongSunlight'], false);

      device.forceLowBattery(true);
      expect(device.debugFlags['forceLowBattery'], true);
    });
  });

  group('FakeUmbrellaDevice - stateStream', () {
    test('stateStream emits updates on state changes', () async {
      final positions = <UmbrellaPosition>[];
      final sub = device.stateStream.listen(
        (s) => positions.add(s.umbrellaPosition),
      );

      await device.connect();
      await device.openUmbrella();
      // Allow stream events to propagate
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();

      expect(positions, contains(UmbrellaPosition.opening));
      expect(positions, contains(UmbrellaPosition.open));
    });
  });
}
