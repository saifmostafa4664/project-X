import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/device/esp32_umbrella_device.dart';
import 'package:usmart/device/models/umbrella_state.dart';

void main() {
  late ESP32UmbrellaDevice device;

  setUp(() {
    device = ESP32UmbrellaDevice();
  });

  tearDown(() {
    device.dispose();
  });

  group('ESP32UmbrellaDevice', () {
    test('isSimulation returns false', () {
      expect(device.isSimulation, false);
    });

    test('isConnected is false initially', () {
      expect(device.isConnected, false);
    });

    test('currentState returns initial state', () {
      expect(
        device.currentState.connectionStatus,
        ConnectionStatus.disconnected,
      );
      expect(device.currentState.umbrellaPosition, UmbrellaPosition.closed);
    });

    test('stateStream is a broadcast stream', () {
      expect(device.stateStream, isA<Stream<UmbrellaDeviceState>>());
    });

    test('connect throws UnimplementedError', () {
      expect(() => device.connect(), throwsA(isA<UnimplementedError>()));
    });

    test('disconnect throws UnimplementedError', () {
      expect(() => device.disconnect(), throwsA(isA<UnimplementedError>()));
    });

    test('openUmbrella throws UnimplementedError', () {
      expect(() => device.openUmbrella(), throwsA(isA<UnimplementedError>()));
    });

    test('closeUmbrella throws UnimplementedError', () {
      expect(() => device.closeUmbrella(), throwsA(isA<UnimplementedError>()));
    });

    test('stopUmbrella throws UnimplementedError', () {
      expect(() => device.stopUmbrella(), throwsA(isA<UnimplementedError>()));
    });

    test('toggleLight throws UnimplementedError', () {
      expect(
        () => device.toggleLight(true),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('setRGBColor throws UnimplementedError', () {
      expect(
        () => device.setRGBColor(const Color(0xFFFF0000)),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('setBrightness throws UnimplementedError', () {
      expect(
        () => device.setBrightness(50),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('setLightingMode throws UnimplementedError', () {
      expect(
        () => device.setLightingMode(LightingMode.party),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('playMusic throws UnimplementedError', () {
      expect(() => device.playMusic(), throwsA(isA<UnimplementedError>()));
    });

    test('pauseMusic throws UnimplementedError', () {
      expect(() => device.pauseMusic(), throwsA(isA<UnimplementedError>()));
    });

    test('setVolume throws UnimplementedError', () {
      expect(
        () => device.setVolume(50),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('getStatus throws UnimplementedError', () {
      expect(() => device.getStatus(), throwsA(isA<UnimplementedError>()));
    });

    test('refreshState throws UnimplementedError', () {
      expect(() => device.refreshState(), throwsA(isA<UnimplementedError>()));
    });
  });

  group('CommunicationProtocol', () {
    test('has all expected values', () {
      expect(CommunicationProtocol.values.length, 3);
      expect(
        CommunicationProtocol.values,
        containsAll([
          CommunicationProtocol.ble,
          CommunicationProtocol.wifi,
          CommunicationProtocol.websocket,
        ]),
      );
    });
  });
}
