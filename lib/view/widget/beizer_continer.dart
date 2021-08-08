import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sea_oil/constant/custom_colors.dart';
import 'package:sea_oil/viewmodel/widget/clip_painter.dart';

class BezierContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5,
        child: ClipPath(
          clipper: ClipPainter(),
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration:const  BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [CustomColors.purple500, CustomColors.primary])),
          ),
        ),
      ),
    );
  }
}
