import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:sea_oil/model/exception/location_denied.dart';
import 'package:sea_oil/model/exception/location_denied_forever.dart';
import 'package:sea_oil/model/exception/location_service_disable.dart';

class LocationManager {
  factory LocationManager() => _instance;

  LocationManager._();

  int sample = 3;

  static final LocationManager _instance = LocationManager._();

  Position? myCurrentPosition;
  late StreamSubscription<Position> positionStream;
  late StreamSubscription<ServiceStatus> providerStream;

  Future<void> init() async {
    _initPositionListener();
    _initProviderStream();
    await determinePosition();
  }

  void _initProviderStream() {
    providerStream = Geolocator.getServiceStatusStream().listen((event) {});
  }

  void _initPositionListener() {
    positionStream =
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 3)).listen((event) { });

  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw LocationServiceDisable('Service disable');
    }

    permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw LocationDenied('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      throw LocationDeniedForever(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<LocationPermission> checkPermission()async{
    return await Geolocator.checkPermission();
  }

  Future<Position> getCurrentPosition()async{
    return await Geolocator.getCurrentPosition();
  }

  void dispose() {
    positionStream.cancel();
    providerStream.cancel();
  }
}
