
import 'dart:convert';

import 'package:sea_oil/model/station.dart';
import 'package:sea_oil/repository/api.dart';
import 'package:http/http.dart' as http;

import '../env.dart';

class StationRepository{
  factory StationRepository(Api apiProvider)=>StationRepository._(apiProvider);
  StationRepository._(this._api);
  Api _api;

  Future<List<Station>> getStations() async{
    final http.Response response = await _api.get('${Env.endPoint}stations?all');
    final Map<String, dynamic> data = json.decode(response.body);

    final List<dynamic> mapList =data['data'] ?? [];

    final List<Station> stations = <Station>[];

    for (final Map<String, dynamic> map in mapList) {
      final Station station = Station.fromJson(map);
      stations.add(station);
    }
    return stations;
  }
}