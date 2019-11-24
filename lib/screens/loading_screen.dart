import 'package:flutter/material.dart';
import 'package:maxes/constants.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: kBackgroundConfig,
        child: Center(
          child: Text(
            'Loading',
            style: kBigTextStyle,
          ),
        ),
      ),
    );
  }
}
