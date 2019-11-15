import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxes/widgets/auth_button.dart';
import 'package:maxes/widgets/auth_text_input.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:maxes/constants.dart';
import 'package:maxes/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:maxes/widgets/error_dialog.dart';
import 'package:maxes/screens/home_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/changePassword';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String _oldPassword;
  String _newPassword;

  void oldPasswordCallback(String value) => _oldPassword = value;
  void newPasswordCallback(String value) => _newPassword = value;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: kBackgroundConfig,
        child: KeyboardAvoider(
          autoScroll: true,
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Change Your Password',
                  textAlign: TextAlign.center,
                  style: kBigTextStyle,
                ),
                SizedBox(height: 15.0),
                Text(
                  'To change your password enter your old password and then enter your new password.',
                  textAlign: TextAlign.center,
                  style: kInstructionsTextStyle,
                ),
                SizedBox(height: 15.0),
                AuthTextInput(
                  hintText: 'Old Password',
                  faIcon: FontAwesomeIcons.lock,
                  callback: oldPasswordCallback,
                  obscureText: true,
                ),
                SizedBox(height: 15.0),
                AuthTextInput(
                  hintText: 'New Password',
                  faIcon: FontAwesomeIcons.lock,
                  callback: newPasswordCallback,
                  obscureText: true,
                ),
                SizedBox(height: 15.0),
                AuthButton(
                  buttonText: 'CHANGE PASSWORD',
                  buttonColor: kButtonColor,
                  onPressed: () async {
                    try {
                      await Provider.of<Auth>(context).changePassword(_oldPassword, _newPassword);
                      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                    } catch (e) {
                      _showErrorDialog(e.message);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
