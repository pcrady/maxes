import 'package:flutter/material.dart';
import 'package:maxes/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:maxes/widgets/auth_button.dart';
import 'package:maxes/widgets/auth_text_input.dart';
import 'package:maxes/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:maxes/widgets/error_dialog.dart';
import 'package:maxes/screens/home_screen.dart';

class ConfirmAccountScreen extends StatefulWidget {
  static const routeName = '/confirmAccount';
  final String email;
  final String password;

  ConfirmAccountScreen({this.email, this.password});

  @override
  _ConfirmAccountScreenState createState() => _ConfirmAccountScreenState();
}

class _ConfirmAccountScreenState extends State<ConfirmAccountScreen> {

  String _confirmationCode;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message),
    );
  }

  void confirmCallback() async {
    try {
      await Provider.of<Auth>(context).confirmUser(_confirmationCode);
      await Provider.of<Auth>(context).authenticateUser(widget.password);
      await Provider.of<Auth>(context).getCognitoCredentials();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (e) {
      _showErrorDialog(e.message);
    }
  }

  void confirmCodeCallback(String value) => _confirmationCode = value;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: kBackgroundConfig,
        child: KeyboardAvoider(
          autoScroll: true,
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enter Your Confirmation Code',
                  textAlign: TextAlign.center,
                  style: kBigTextStyle,
                ),
                SizedBox(height: 15.0),
                Text(
                  'Enter the confirmation code that we sent to ${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 15.0),
                AuthTextInput(
                  hintText: 'Confirmation Code',
                  faIcon: FontAwesomeIcons.key,
                  callback: confirmCodeCallback,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15.0),
                AuthButton(
                  buttonText: 'CONFIRM',
                  buttonColor: kButtonColor,
                  onPressed: confirmCallback,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
