import 'package:findmechanice/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text(
          'Loading...',
          style: widgetStyle1,
        ),
      )),
    );
  }
}
