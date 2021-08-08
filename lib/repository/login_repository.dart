import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sea_oil/model/auth.dart';
import 'package:sea_oil/model/exception/invalid_credentials.dart';
import 'package:sea_oil/repository/api.dart';

import '../env.dart';

class LoginRepository {
  factory LoginRepository(Api api) => LoginRepository._(api);

  LoginRepository._(this._api);

  Api _api;

  Future<Auth> login(Map<String, String> credentials) async {
    final http.Response response = await _api.post(
      '${Env.endPoint}v2/sessions',
      credentials,
    );
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['status'] != 'success') {
      throw InvalidCredentials('Invalid Credentials!');
    }

    return Auth.fromJson(data['data']);
  }
}
