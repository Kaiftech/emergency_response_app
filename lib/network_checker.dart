import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkChecker {
  final StreamController<bool> _connectionStatusController =
  StreamController<bool>();

  Future<bool> _checkConnection() async {
    try {
      final response = await http.head(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void connectivityStream() async {
    // Periodically check connectivity status and push it to the stream.
    while (true) {
      bool isConnected = await _checkConnection();
      _connectionStatusController.sink.add(isConnected);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Stream<bool> get connectionStatusStream =>
      _connectionStatusController.stream;

  void dispose() {
    _connectionStatusController.close();
  }
}