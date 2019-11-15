import 'package:flutter/material.dart';
import 'package:maxes/constants.dart';

class AuthButton extends StatelessWidget {
  String buttonText;
  Color buttonColor;
  Function onPressed;

  AuthButton({this.buttonText, this.buttonColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [kBoxShadow],
      ),
      width: double.infinity,
      child: RaisedButton(
        color: buttonColor,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          this.onPressed();
        },
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}