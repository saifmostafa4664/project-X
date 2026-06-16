import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/device/umbrella_device_interface.dart';

void main() {
  group('DeviceException hierarchy', () {
    test('DeviceNotConnectedException has default message', () {
      const ex = DeviceNotConnectedException();
      expect(ex.message, 'Device not connected');
      expect(ex.originalError, isNull);
      expect(ex.toString(), contains('DeviceNotConnectedException'));
      expect(ex.toString(), contains('Device not connected'));
    });

    test('DeviceNotConnectedException accepts custom message', () {
      const ex = DeviceNotConnectedException('Custom msg');
      expect(ex.message, 'Custom msg');
    });

    test('DeviceConnectionException stores message and error', () {
      final original = Exception('root cause');
      final ex = DeviceConnectionException('connection failed', original);
      expect(ex.message, 'connection failed');
      expect(ex.originalError, original);
      expect(ex.toString(), contains('DeviceConnectionException'));
    });

    test('UmbrellaOperationException stores message', () {
      const ex = UmbrellaOperationException('op failed');
      expect(ex.message, 'op failed');
      expect(ex.toString(), contains('UmbrellaOperationException'));
    });

    test('DeviceTimeoutException has default message', () {
      const ex = DeviceTimeoutException();
      expect(ex.message, 'Operation timed out');
    });

    test('DeviceCommunicationException stores message and error', () {
      final original = Exception('network');
      final ex = DeviceCommunicationException('comm failed', original);
      expect(ex.message, 'comm failed');
      expect(ex.originalError, original);
    });

    test('all exceptions implement Exception', () {
      const ex1 = DeviceNotConnectedException();
      const ex2 = DeviceConnectionException('msg');
      const ex3 = UmbrellaOperationException('msg');
      const ex4 = DeviceTimeoutException();
      const ex5 = DeviceCommunicationException('msg');

      expect(ex1, isA<Exception>());
      expect(ex2, isA<Exception>());
      expect(ex3, isA<Exception>());
      expect(ex4, isA<Exception>());
      expect(ex5, isA<Exception>());
    });
  });
}
