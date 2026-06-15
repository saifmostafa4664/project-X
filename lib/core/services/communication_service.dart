library;

import 'dart:async';

abstract class CommunicationService {
  Stream<List<int>> get dataStream;

  bool get isConnected;

  Future<bool> connect(String address);

  Future<void> disconnect();

  Future<void> send(List<int> data);

  void dispose();
}

class BleCommunicationService extends CommunicationService {
  final _dataController = StreamController<List<int>>.broadcast();
  bool _connected = false;

  @override
  Stream<List<int>> get dataStream => _dataController.stream;

  @override
  bool get isConnected => _connected;

  @override
  Future<bool> connect(String address) async {
    throw UnimplementedError('BLE not yet implemented');
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<void> send(List<int> data) async {
    throw UnimplementedError('BLE send not yet implemented');
  }

  @override
  void dispose() {
    _dataController.close();
  }
}

class WifiCommunicationService extends CommunicationService {
  final _dataController = StreamController<List<int>>.broadcast();
  bool _connected = false;

  @override
  Stream<List<int>> get dataStream => _dataController.stream;

  @override
  bool get isConnected => _connected;

  @override
  Future<bool> connect(String address) async {
    throw UnimplementedError('WiFi not yet implemented');
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<void> send(List<int> data) async {
    throw UnimplementedError('WiFi send not yet implemented');
  }

  @override
  void dispose() {
    _dataController.close();
  }
}

class WebSocketCommunicationService extends CommunicationService {
  final _dataController = StreamController<List<int>>.broadcast();
  bool _connected = false;

  @override
  Stream<List<int>> get dataStream => _dataController.stream;

  @override
  bool get isConnected => _connected;

  @override
  Future<bool> connect(String address) async {
    throw UnimplementedError('WebSocket not yet implemented');
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<void> send(List<int> data) async {
    throw UnimplementedError('WebSocket send not yet implemented');
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
