// ignore: file_names
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thuyngoc/Beacon/BeaconManager.dart';
import 'package:thuyngoc/Beacon/GTCuaHang.dart';
import 'package:thuyngoc/Beacon/LocationManager.dart';
//import 'package:marker_icon/marker_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:thuyngoc/Beacon/ScanQr.dart';

//  PolygonLayerOptions polygonOptions = PolygonLayerOptions(
//   polygons: [
//     Polygon(
//       points: [
//         LatLng(51.5, -0.1),
//         LatLng(51.6, -0.2),
//         LatLng(51.7, -0.1),
//       ],
//       color: Colors.blue.withOpacity(0.5),
//       borderColor: Colors.blue,
//       borderStrokeWidth: 2.0,
//     ),
//   ],
// );
// CircleLayerOptions circleOptions = CircleLayerOptions(
//   circles: [
//     CircleMarker(
//       point: LatLng(51.5, -0.1),
//       radius: 10,
//       color: Colors.red.withOpacity(0.5),
//       borderColor: Colors.red,
//       borderStrokeWidth: 2.0,
//     ),
//   ],
// );
class BeaconMap extends StatefulWidget {
  @override
  _BeaconMapState createState() => _BeaconMapState();
}

class _BeaconMapState extends State<BeaconMap> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final BeaconManager _beaconManager = new BeaconManager();
  // ignore: unnecessary_new
  final LocationManager _locationManager = new LocationManager();
  late LatLng _currentPositionLatLng = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _setupLocationServices();
  }

//late Location location = new Location();
  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  void _moveCameraToCurrentPosition() {
    if (_currentPositionLatLng != null) {
      _mapController.move(_currentPositionLatLng, 18.0);
    }
  }

  Marker _userLocationMarker = Marker(
    width: 40.0,
    height: 40.0,
    point: LatLng(0, 0),
    child: Icon(
      Icons.phone_android,
      color: Colors.blue,
      size: 40,
    ),
  );

  void _setupLocationServices() async {
    await _checkPermissions();

    Position currentPosition = await _locationManager.getCurrentLocation();
    setState(() {
      _currentPositionLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      _userLocationMarker = Marker(
        width: 40.0,
        height: 40.0,
        point: _currentPositionLatLng,
        child: Icon(
          Icons.phone_android_outlined,
          color: Colors.blue,
          size: 40,
        ),
      );
    });

    _moveCameraToCurrentPosition();
  }

  double _currentZoom = 19.0; // Initial zoom level
  double _minZoom = 18.0; // Minimum allowed zoom level
  double _maxZoom = 20.0; // Maximum allowed zoom level

  //double _safetyZoneRadius = 150;
  double _safetyZoneRadius = 0.0;
  bool _showSlider = false;

// Method to create a marker for a beacon
// Marker _createBeaconMarker(LatLng position, double distance) {
//   return Marker(
//     width: 80.0,
//     height: 80.0,
//     point: position,
//     builder: (ctx) => Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           FlutterLogo(size: 40, colors: Colors.red),
//           Text('${distance.toStringAsFixed(2)} m',
//               style: TextStyle(fontSize: 12, color: Colors.black)),
//         ],
//       ),
//     ),
//   );
// }

  bool _hasDevice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Vị trí thú cưng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 136, 202, 191),
      ),
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          // Update the zoom level based on the scaling factor
          double newZoom = _currentZoom * details.scale;

          // Ensure the new zoom level is within the allowed range
          if (newZoom >= _minZoom && newZoom <= _maxZoom) {
            setState(() {
              _currentZoom = newZoom;
            });
          }
        },
        child: Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPositionLatLng,
              zoom: _currentZoom,
              maxZoom: _maxZoom,
              minZoom: _minZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  _userLocationMarker,
                ],
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _currentPositionLatLng,
                    radius: 150, // Set the radius of the safety zone in meters
                    color: Color.fromARGB(255, 152, 250, 193).withOpacity(0.3),
                    borderColor: Colors.red,
                    borderStrokeWidth: 2.0,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        // Xử lý sự kiện thay đổi giá trị trong ô tìm kiếm
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        hintStyle: TextStyle(color: Colors.black87),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 163, 212, 183),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.wifi,
                              color: Colors.black,
                            ),
                            Text(
                              "Thiết bị",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          _showSlider
                              ? Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Column(
                                    children: [
                                      Slider(
                                        value: _safetyZoneRadius,
                                        min: 0,
                                        max: 500,
                                        onChanged: (value) {
                                          setState(() {
                                            _safetyZoneRadius = value;
                                          });
                                        },
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Save the selected radius or perform any other actions
                                          // You can access the selected radius using _safetyZoneRadius
                                          print(
                                              'Selected Radius: $_safetyZoneRadius');
                                          // You can also hide the slider
                                          setState(() {
                                            _showSlider = false;
                                          });
                                        },
                                        child: Text('Lưu lại'),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(), // Ẩn thanh kéo khi _showSlider là false
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showSlider =
                                    !_showSlider; // Đảo ngược trạng thái hiển thị của thanh kéo
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 163, 212, 183),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.health_and_safety_outlined,
                                  color: Colors.black,
                                ),
                                Text(
                                  "An toàn",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 163, 212, 183),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                            ),
                            Text(
                              "Dịch vụ",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 501,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      width: MediaQuery.of(context)
                          .size
                          .width, // Set width to full screen width
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      child: _hasDevice
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // ElevatedButton(
                                //   onPressed: () {
                                //     // Handle "Thêm thiết bị" button press
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //     primary: Colors.green,
                                //   ),
                                //   child: Text('Thêm thiết bị'),
                                // ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     // Handle "Mua ngay" button press
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //     primary: Colors
                                //         .blue, // You can change the color accordingly
                                //   ),
                                //   child: Text('Mua ngay'),
                                // ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Bạn có thiết bị chưa ?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                       Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanQr()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      child: Text(
                                        'Thêm thiết bị',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StoreInfoScreen()), // Replace 'StoreInfoScreen' with the actual screen class
    );
                                        // Handle "Mua ngay" button press
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors
                                            .blue, // You can change the color accordingly
                                      ),
                                      child: Text(
                                        'Mua ngay',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // 2. Quét các thiết bị beacon gần đó
      //     List<Beacon> nearbyBeacons = await _beaconManager.scanNearbyBeacons(
      //         timeout: const Duration(seconds: 4));
      //     // 3. Thêm đánh dấu trên bản đồ cho mỗi beacon
      //     for (Beacon beacon in nearbyBeacons) {
      //       // Randomize the location around the user's current position
      //       LatLng beaconLocation =
      //           generateRandomLatLng(_currentPositionLatLng, beacon.distance);
      //       LatLng beaconLatLng =
      //           LatLng(beaconLocation.latitude, beaconLocation.longitude);
      //       // Tạo một đánh dấu mới trên bản đồ với thông tin vị trí và khoảng cách của beacon
      //       //_addMarker(beacon, beaconLatLng);
      //     }

      //     // 4. Di chuyển camera của bản đồ để hiển thị tất cả các đánh dấu
      //     _moveCameraToShowAllMarkers();
      //   },
      //   child: Icon(
      //     Icons.refresh,
      //     color: Colors.black,
      //   ),
      //   backgroundColor: Color.fromARGB(255, 136, 202, 191),
      // ),
    );
  }

//   // ... (remaining code)

  // Di chuyển camera của bản đồ để hiển thị tất cả các đánh dấu
  void _moveCameraToShowAllMarkers() {
    // Đảm bảo rằng bạn đã thêm ít nhất một đánh dấu vào bản đồ trước khi thử di chuyển camera
    if (_markers.isNotEmpty) {
      double north = _markers.first.point.latitude;
      double south = _markers.first.point.latitude;
      double east = _markers.first.point.longitude;
      double west = _markers.first.point.longitude;

      for (Marker marker in _markers) {
        if (marker.point.latitude > north) north = marker.point.latitude;
        if (marker.point.latitude < south) south = marker.point.latitude;
        if (marker.point.longitude > east) east = marker.point.longitude;
        if (marker.point.longitude < west) west = marker.point.longitude;
      }

      // Thiết lập các giới hạn của bản đồ để hiển thị tất cả các đánh dấu
      LatLngBounds bounds =
          LatLngBounds(LatLng(south, west), LatLng(north, east));

      // Di chuyển camera để hiển thị tất cả các đánh dấu trong vùng giới hạn
      _mapController.fitBounds(
        bounds,
        options: FitBoundsOptions(
          padding: EdgeInsets.all(
              50), // Đặt đệm cho các đánh dấu ở các cạnh của bản đồ
        ),
      );
    }
  }

// This function generates a random LatLng within the given distance from the given center
  LatLng generateRandomLatLng(LatLng center, num distance) {
    Random random = Random();

    // Convert distance to radians
    double distanceInRadians = distance / 6371000;

    // Generate random bearing (direction) and random distance within the given distance
    double randomBearing = random.nextDouble() * 2 * pi;
    double randomDistance = sqrt(random.nextDouble()) * distanceInRadians;

    // Convert the center LatLng to radians
    double centerLatInRadians = degreesToRadians(center.latitude);
    double centerLngInRadians = degreesToRadians(center.longitude);

    // Calculate the random LatLng
    double randomLatInRadians = asin(
        sin(centerLatInRadians) * cos(randomDistance) +
            cos(centerLatInRadians) * sin(randomDistance) * cos(randomBearing));
    double randomLngInRadians = centerLngInRadians +
        atan2(
            sin(randomBearing) * sin(randomDistance) * cos(centerLatInRadians),
            cos(randomDistance) -
                sin(centerLatInRadians) * sin(randomLatInRadians));

    // Convert the random LatLng back to degrees
    double randomLat = radiansToDegrees(randomLatInRadians);
    double randomLng = radiansToDegrees(randomLngInRadians);

    return LatLng(randomLat - 0.0001000, randomLng - 0.0001000);
    //return LatLng(randomLat, randomLng);
  }
}

// Marker _createBeaconMarker(LatLng beaconLocation, num distance) {
//   return Marker(
//     width: 80.0,
//     height: 80.0,
//     point: beaconLocation,
//     builder: (ctx) => Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           FlutterLogo(size: 40, colors: Colors.red),
//           Text('${distance.toStringAsFixed(2)} m',
//               style: TextStyle(fontSize: 12, color: Colors.black)),
//         ],
//       ),
//     ),
//   );
// }

class YourMarkerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.phone_android_outlined,
      color: Colors.blue,
      size: 40,
    );
  }
}

class UserAvatar extends StatefulWidget {
  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotationAnimation,
      child: GestureDetector(
        onTap: () {
          if (_animationController.isAnimating) {
            _animationController.stop();
          } else {
            _animationController.forward();
          }
        },
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/Logo.png'),
          radius: 30,
        ),
      ),
    );
  }
}

class BouncingUserAvatar extends StatefulWidget {
  @override
  _BouncingUserAvatarState createState() => _BouncingUserAvatarState();
}

class _BouncingUserAvatarState extends State<BouncingUserAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _animationController.forward();
      },
      onTapUp: (TapUpDetails details) {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _animation.value,
            child: child ??
                CircleAvatar(
                  backgroundImage: AssetImage('assets/Logo.png'),
                  radius: 30,
                ),
          );
        },
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/Logo.png'),
          radius: 30,
        ),
      ),
    );
  }
}
