import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/core/services/communication_service.dart';

void main() {
  group('BleCommunicationService', () {
    late BleCommunicationService service;

    setUp(() {
      service = BleCommunicationService();
    });

    tearDown(() {
      service.dispose();
    });

    test('isConnected is initially false', () {
      expect(service.isConnected, false);
    });

    test('connect throws UnimplementedError', () {
      expect(
        () => service.connect('address'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('send throws UnimplementedError', () {
      expect(
        () => service.send([1, 2, 3]),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('disconnect sets isConnected to false', () async {
      await service.disconnect();
      expect(service.isConnected, false);
    });

    test('dataStream is accessible', () {
      expect(service.dataStream, isA<Stream<List<int>>>());
    });
  });

  group('WifiCommunicationService', () {
    late WifiCommunicationService service;

    setUp(() {
      service = WifiCommunicationService();
    });

    tearDown(() {
      service.dispose();
    });

    test('isConnected is initially false', () {
      expect(service.isConnected, false);
    });

    test('connect throws UnimplementedError', () {
      expect(
        () => service.connect('192.168.1.1'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('send throws UnimplementedError', () {
      expect(
        () => service.send([0xFF]),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('disconnect sets isConnected to false', () async {
      await service.disconnect();
      expect(service.isConnected, false);
    });
  });

  group('WebSocketCommunicationService', () {
    late WebSocketCommunicationService service;

    setUp(() {
      service = WebSocketCommunicationService();
    });

    tearDown(() {
      service.dispose();
    });

    test('isConnected is initially false', () {
      expect(service.isConnected, false);
    });

    test('connect throws UnimplementedError', () {
      expect(
        () => service.connect('ws://localhost'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('send throws UnimplementedError', () {
      expect(
        () => service.send([1]),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('disconnect sets isConnected to false', () async {
      await service.disconnect();
      expect(service.isConnected, false);
    });

    test('dataStream is accessible', () {
      expect(service.dataStream, isA<Stream<List<int>>>());
    });
  });
}
