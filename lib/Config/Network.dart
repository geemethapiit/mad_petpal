import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivityPage extends StatefulWidget {
  @override
  _NetworkConnectivityPageState createState() => _NetworkConnectivityPageState();
}

class _NetworkConnectivityPageState extends State<NetworkConnectivityPage> {
  String connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  // Method to check the network connectivity
  Future<void> _checkConnectivity() async {
    var result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    // Listen for changes in network connectivity
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  // Update the connection status based on the result
  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => connectionStatus = 'Connected to Wi-Fi');
        break;
      case ConnectivityResult.mobile:
        setState(() => connectionStatus = 'Connected to Mobile Data');
        break;
      case ConnectivityResult.none:
        setState(() => connectionStatus = 'No Internet Connection');
        break;
      default:
        setState(() => connectionStatus = 'Unknown Connection');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Connectivity'),
      ),
      body: Center(
        child: Text(
          'Connection Status: $connectionStatus',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
