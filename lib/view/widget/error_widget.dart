import 'package:flutter/cupertino.dart';

class CustomErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          child: const Text('Error'),
        ),
      ),
    );
  }
}