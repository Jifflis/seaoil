import 'dart:convert';

import 'package:flutter/services.dart';

class Env {

  String tag = 'env';

  static Map<String, dynamic>? _env;

  static Future<void> initEnv() async {
    _env = json.decode(await rootBundle.loadString('.env'));
  }

  /// Get endpoint.
  ///
  static String get endPoint => _env ?['endpoint'];

}