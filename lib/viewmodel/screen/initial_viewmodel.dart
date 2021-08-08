import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/constant/routes.dart';
import 'package:sea_oil/model/auth.dart';
import 'package:sea_oil/util/db_manager.dart';
import 'package:sea_oil/viewmodel/authenticationViewmodel.dart';

class InitialViewModel with ChangeNotifier {
  bool _isInit = false;

  Future<void> init(BuildContext context) async {
    if (_isInit) return;
    _isInit = true;

    Auth? auth;
    String result = '';

    auth = await DbManager.getAuth();

    if (auth == null) {
      result = Routes.login_screen;
    } else {
      Provider.of<AuthenticationViewmodel>(context, listen: false).auth = auth;
      result = Routes.main_screen;
    }

    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacementNamed(context, result);
  }
}
