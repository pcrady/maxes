import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxes/widgets/auth_button.dart';
import 'package:maxes/widgets/auth_text_input.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:maxes/constants.dart';
import 'package:maxes/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:maxes/widgets/error_dialog.dart';
import 'package:maxes/screens/auth/login_screen.dart';

enum ForgotScreenVersion {
  enterEmail,
  enterCodeAndPassword,
}

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgotPassword';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotScreenVersion _screenVersion = ForgotScreenVersion.enterEmail;

  String _email;
  String _confirmationCode;
  String _newPassword;
  final TextEditingController _controller = new TextEditingController();

  void emailCallback(String value) => _email = value;

  void confirmationCodeCallback(String value) => _confirmationCode = value;

  void newPasswordCallback(String value) => _newPassword = value;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message),
    );
  }

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
                  'Forgot Your Password?',
                  textAlign: TextAlign.center,
                  style: kBigTextStyle,
                ),
                SizedBox(height: 15.0),
                Text(
                  'To recover your password, you need to enter your registered email address. We will send the recovery code to your email.',
                  textAlign: TextAlign.center,
                  style: kInstructionsTextStyle,
                ),
                SizedBox(height: 15.0),
                AuthTextInput(
                  hintText: _screenVersion == ForgotScreenVersion.enterEmail
                      ? 'Email'
                      : 'Confirmation Code',
                  faIcon: _screenVersion == ForgotScreenVersion.enterEmail
                      ? FontAwesomeIcons.envelope
                      : FontAwesomeIcons.key,
                  callback: _screenVersion == ForgotScreenVersion.enterEmail
                      ? emailCallback
                      : confirmationCodeCallback,
                  controller: _controller,
                  keyboardType: _screenVersion == ForgotScreenVersion.enterEmail
                      ? TextInputType.emailAddress
                      : TextInputType.number,
                ),
                _screenVersion == ForgotScreenVersion.enterEmail
                    ? Container()
                    : SizedBox(height: 15.0),
                _screenVersion == ForgotScreenVersion.enterEmail
                    ? Container()
                    : AuthTextInput(
                        hintText: 'New Password',
                        faIcon: FontAwesomeIcons.lock,
                        callback: newPasswordCallback,
                        obscureText: true,
                      ),
                SizedBox(height: 15.0),
                AuthButton(
                  buttonText: _screenVersion == ForgotScreenVersion.enterEmail
                      ? 'SEND'
                      : 'RESET PASSWORD',
                  buttonColor: kButtonColor,
                  onPressed: () async {
                    if (_screenVersion == ForgotScreenVersion.enterEmail) {
                      try {
                        await Provider.of<Auth>(context).init(email: _email);
                        await Provider.of<Auth>(context).sendForgotPasswordCode();
                        setState(() {
                          _controller.clear();
                          _screenVersion = ForgotScreenVersion.enterCodeAndPassword;
                        });
                      } catch (e) {
                        _showErrorDialog(e.message);
                      }
                    } else {
                      try {
                        await Provider.of<Auth>(context).init(email: _email);
                        await Provider.of<Auth>(context)
                            .confirmForgotPasswordCode(
                                _confirmationCode, _newPassword);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.routeName,
                            (Route<dynamic> route) => false);
                      } catch (e) {
                        _showErrorDialog(e.message);
                      }
                    }
                  },
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Register Account Or Login'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
