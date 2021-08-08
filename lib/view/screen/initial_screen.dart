import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/constant/custom_colors.dart';
import 'package:sea_oil/viewmodel/screen/initial_viewmodel.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<InitialViewModel>(context, listen: false).init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:const <Widget>[
            Icon(
              Icons.location_searching_outlined,
              color: CustomColors.purple500,
            ),
            SizedBox(
              height: 8,
            ),
             Text(
              'Sea oil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
