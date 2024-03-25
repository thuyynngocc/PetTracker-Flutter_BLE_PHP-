import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

// Sử dụng hàm radians và degrees
double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

double radiansToDegrees(double radians) {
  return radians * 180 / pi;
}

class Beacon {
  final String name;
  final num distance;
  Beacon({required this.name, required this.distance});
}

class BeaconManager {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();

  Future<List<Beacon>> scanNearbyBeacons({required Duration timeout}) async {
    List<Beacon> beacons = [];
    // Implement beacon scanning functionality
    // You may need to customize the scanning logic based on your beacon device and its advertising data
    FlutterBluePlus.startScan(timeout: timeout);
    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        // Process the result and extract beacon information
        final String name = result.advertisementData.localName!;
        if (name.isNotEmpty) {
          final int rssi = result.rssi;
          // You need to know the transmitted power of the beacon (in dBm) and the environment factor
          const int txPower = -59; // This is just an example value, you need to know the actual value
          const double environmentFactor = 2.0; // This is just an example value
          // Calculate the distance based on the RSSI and the transmitted power

          num distance = pow(10, (txPower - rssi) / (10 * environmentFactor));
          if (result.device.name == "PetTracker") {
            beacons.add(Beacon(name: name, distance: distance));
          }

          print("Name: $name - $distance");
        }
      }
    });
    FlutterBluePlus.stopScan();
    return beacons;
  }
}