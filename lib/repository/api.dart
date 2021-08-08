import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sea_oil/viewmodel/authenticationViewmodel.dart';
class Api{

  Api(this.model){
    _headers = <String, String>{
      'Authorization': model.auth?.token??'',
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
  }

  late Map<String, String> _headers;
  AuthenticationViewmodel model;

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    http.Response responseJson;
    try {
      final http.Response response =
      await http.get(Uri.parse(url), headers: headers??_headers);
      responseJson = _response(response);
    } on SocketException {
      throw const HttpException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String,String> body) async {
    http.Response responseJson;
    try {
      final http.Response response =
      await http.post(Uri.parse(url),body: jsonEncode(body),headers: _headers);
      responseJson = _response(response);
    } on SocketException {
      throw const HttpException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw HttpException(response.body.toString());
      case 401:

      case 403:
        throw HttpException(response.body.toString());
      case 500:

      default:
        throw HttpException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}