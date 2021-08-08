import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/repository/api.dart';
import 'package:sea_oil/repository/login_repository.dart';
import 'package:sea_oil/view/screen/home_screen.dart';
import 'package:sea_oil/view/screen/login_screen.dart';
import 'package:sea_oil/view/screen/search_screen.dart';
import 'package:sea_oil/viewmodel/authenticationViewmodel.dart';
import 'package:sea_oil/viewmodel/screen/home_screen_viewmodel.dart';
import 'package:sea_oil/viewmodel/screen/login_viewmodel.dart';
import 'package:sea_oil/viewmodel/screen/search_screen_viewmodel.dart';
import 'package:sea_oil/viewmodel/widget/map_viewmodel.dart';

class Routes {
  static const String initial = '/';
  static const String main_screen = '/main_screen';
  static const String login_screen = '/login_screen';
  static const String search_screen = '/search_screen';

  static Map<String, Widget Function(BuildContext)> routes = {
    search_screen: (context) =>
        ChangeNotifierProvider<SearchScreenViewmodel>(
          create: (_) => SearchScreenViewmodel(),
          child: SearchScreen(),
        ),
    main_screen: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<HomeScreenViewModel>(
              create: (BuildContext context) => HomeScreenViewModel(),
            ),
            ChangeNotifierProvider<MapViewModel>(
              create: (BuildContext context) => MapViewModel(),
            ),
          ],
          child: HomeScreen(),
        ),
    login_screen: (context) => ChangeNotifierProvider<LoginViewModel>(
          create: (_) => LoginViewModel(
            LoginRepository(
              Api(
                Provider.of<AuthenticationViewmodel>(context, listen: false),
              ),
            ),
          ),
          child: LoginScreen(),
        ),
  };
}
