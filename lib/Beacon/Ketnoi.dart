import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'dart:async';

void connectToDevice() async {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  Timer scanTimeout;

  // Start scanning
  FlutterBluePlus.startScan();

  // Set a timeout duration
  const timeoutDuration = Duration(seconds: 5);

  // Start a timer to stop scanning after the timeout duration
  scanTimeout = Timer(timeoutDuration, () {
    FlutterBluePlus.stopScan();
  });

  // Listen for scan results
  FlutterBluePlus.scanResults.listen((scanResults) {
    for (ScanResult scanResult in scanResults) {
      // Check the condition to identify the device to connect to (based on name or MAC address)
      //if (scanResult.device.id.toString() == 'D3:83:2E:F7:B1:DB') {
      if (scanResult.device.name == 'PetTracker') {
        BluetoothDevice device = scanResult.device;
        String mac = device.id.toString();
        
        // Connect to the device
        device.connect().then((_) {
          // Listen for connection state changes
          device.state.listen((state) {
            if (state == BluetoothDeviceState.connected) {
              print('Connected to device: ${device.name}');
              print('Connected to device: ${device.id}');
              // Perform other operations on the connected device
            } else if (state == BluetoothDeviceState.disconnected) {
              print('Disconnected from device: ${device.name}');
              // Handle disconnection
            }
          });
        });
        
        // Stop scanning once the desired device is found
        FlutterBluePlus.stopScan();
        // Cancel the timeout timer
        scanTimeout.cancel();
        break;
      }
    }
  });
}