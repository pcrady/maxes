import 'package:flutter/material.dart';

const Color kBottomColor = Color(0xff541388);
const Color kButtonColor = Color(0xff6cc551);
const Color kTopColor = Color(0xff2de1fc);

const BoxDecoration kBackgroundConfig = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.1, 1.0],
    colors: [kBottomColor, kTopColor],
  ),
);

const BoxShadow kBoxShadow = BoxShadow(
  color: Colors.black45,
  offset: Offset(5.0, 5.0),
  blurRadius: 10.0,
);

const TextStyle kBigTextStyle = TextStyle(
  fontSize: 50.0,
  color: Colors.white,
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  shadows: [
    Shadow(
      color: Colors.black45,
      offset: Offset(5.0, 5.0),
      blurRadius: 20.0,
    ),
  ],
);

const TextStyle kInstructionsTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 15.0,
);