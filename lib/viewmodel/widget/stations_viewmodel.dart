import 'package:geolocator/geolocator.dart';
import 'package:sea_oil/model/station.dart';
import 'package:sea_oil/repository/stationRepository.dart';
import 'package:sea_oil/util/location_manager.dart';
import 'package:sea_oil/viewmodel/base_view_model.dart';

class StationsViewModel extends BaseViewModel {
  StationsViewModel(this._stationRepository) {
    initializeStations();
    calculateDistance();
  }

  List<Station> filteredStations = [];
  List<Station> _stations = [];

  final StationRepository _stationRepository;

  int? _radioValue;

  int? get radioValue => _radioValue;

  set radioValue(int? value) {
    _radioValue = value;
    notifyListeners();
  }

  void resetRadioValue() {
    _radioValue = null;
  }

  ///Initialize [_stations]
  ///
  Future<void> initializeStations() async {
    try {
      isLoading = true;
      isError = false;
      _stations = await _stationRepository.getStations();
      resetFilteredStation();
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  ///Calculate Distance
  ///
  Future<void> calculateDistance() async {
    LocationManager().positionStream.onData((Position position) {
      LocationManager().myCurrentPosition = position;
      for (final Station station in _stations) {
        double distance = Geolocator.distanceBetween(position.latitude,
            position.longitude, station.lat ?? 0.0, station.lng ?? 0.0);
        station.distance = distance;
        if (distance > 1000) {
          distance = distance / 1000;
          station.distanceLabel = '${distance.toStringAsFixed(2)} km away';
        } else {
          station.distanceLabel = '${distance.toStringAsFixed(2)} m away';
        }
      }
      _stations.sort();
      notifyListeners();
    });
  }

  /// Reset filtered station
  ///
  void resetFilteredStation({bool notifyListener = true}) {
    filteredStations = _stations;
    if (notifyListener) {
      notifyListeners();
    }
  }

  ///Search station
  ///
  Future<void> search(String text) async {
    if (text.isEmpty) {
      filteredStations = _stations;
      notifyListeners();
      return;
    }

    final List<Station> filteredStation = [];

    for (final Station station in _stations) {
      if (station.name!.toLowerCase().contains(text.toLowerCase())) {
        filteredStation.add(station);
      }
    }
    filteredStations = filteredStation;
    filteredStations.sort();
    notifyListeners();
  }
}
