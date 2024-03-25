import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationManager {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission;
   
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Not Available');
    }
   
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

 double calculateDistance(LatLng start, LatLng end) {
  final Distance distance = Distance();
  return distance.as(LengthUnit.Meter, start, end);
  }
}
