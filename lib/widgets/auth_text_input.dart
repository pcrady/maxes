import 'package:flutter/material.dart';
import 'package:maxes/constants.dart';

class AuthTextInput extends StatelessWidget {
  String hintText;
  IconData faIcon;
  bool obscureText;
  Function callback;
  TextEditingController controller;

  AuthTextInput(
      {this.hintText, this.faIcon, this.callback, this.controller, this.obscureText: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [kBoxShadow],
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          callback(value);
        },
        obscureText: obscureText,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 15.0),
            child: Icon(
              faIcon,
              color: Colors.black87,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
