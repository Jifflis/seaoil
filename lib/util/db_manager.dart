import 'package:sea_oil/constant/db_key.dart';
import 'package:sea_oil/model/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbManager {
  const DbManager._();

  static Future<Auth?> getAuth() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString(DbKeys.AUTH_TOKEN) ?? '';
    final String expiry = preferences.getString(DbKeys.AUTH_EXPIRY) ?? '';
    if (token.isEmpty ||
        expiry.isEmpty ||
        DateTime.now().isAfter(DateTime.parse(expiry))) {
      return null;
    } else {
      return Auth(token: token, expireDate: DateTime.parse(expiry));
    }
  }

  static Future<void> saveAuth(Auth auth) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(DbKeys.AUTH_TOKEN, auth.token ?? '');
    preferences.setString(DbKeys.AUTH_EXPIRY, auth.expireDate.toString());
  }
}
