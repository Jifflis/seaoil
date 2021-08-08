import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sea_oil/util/location_manager.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel() {
    navigateToMyLocation();
  }

  final Completer<GoogleMapController> controller = Completer();
  final Set<Marker> markers = <Marker>{};
  final CameraPosition initialLocation = const CameraPosition(
    target: LatLng(14.599512, 120.984222),
    zoom: 14.4746,
  );

  /// Animate camera to location
  ///
  Future<void> animateLocation(LatLng location, {double zoom = 15}) async {
    final CameraPosition cameraPosition =
        CameraPosition(target: location, zoom: zoom);

    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  /// Navigate to my location
  ///
  Future<void> navigateToMyLocation() async {
    Position? position = LocationManager().myCurrentPosition;
    position ??= await LocationManager().getCurrentPosition();
    final LatLng location = LatLng(position.latitude, position.longitude);
    animateLocation(location);
  }

  /// Animate to given location and add marker
  ///
  Future<void> animateLocationAndAddMarker(LatLng latLng) async {
    markers.clear();
    addMarker(latLng);
    animateLocation(latLng);

    notifyListeners();
  }

  /// Add a maker
  ///
  void addMarker(LatLng latLng) {
    markers.add(
      Marker(
        markerId: const MarkerId('random'),
        position: latLng,
      ),
    );
  }

}
