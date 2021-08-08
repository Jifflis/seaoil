import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/constant/custom_colors.dart';
import 'package:sea_oil/repository/api.dart';
import 'package:sea_oil/repository/stationRepository.dart';
import 'package:sea_oil/view/screen/initial_screen.dart';
import 'package:sea_oil/viewmodel/authenticationViewmodel.dart';
import 'package:sea_oil/viewmodel/screen/initial_viewmodel.dart';
import 'package:sea_oil/viewmodel/widget/stations_viewmodel.dart';

import 'constant/routes.dart';
import 'env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.initEnv();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationViewmodel>(
          create: (_) => AuthenticationViewmodel(),
        ),
        ChangeNotifierProvider<StationsViewModel>(
          create: (BuildContext context) => StationsViewModel(
            StationRepository(
              Api(
                Provider.of<AuthenticationViewmodel>(context, listen: false),
              ),
            ),
          ),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          initialRoute: Routes.initial,
          routes: Routes.routes,
          theme: ThemeData(primaryColor: CustomColors.primary),
          title: 'Sea oil',
          home: ChangeNotifierProvider<InitialViewModel>(
            create: (BuildContext context) => InitialViewModel(),
            child: InitialScreen(),
          ),
        ),
      ),
    );
  }
}
