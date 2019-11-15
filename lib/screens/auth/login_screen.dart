import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:maxes/widgets/auth_button.dart';
import 'package:maxes/widgets/auth_text_input.dart';
import 'package:maxes/screens/auth/forgot_password_screen.dart';
import 'package:maxes/constants.dart';
import 'package:maxes/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:maxes/widgets/error_dialog.dart';
import 'package:maxes/screens/home_screen.dart';
import 'package:maxes/screens/auth/confirm_account_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum AuthScreenVersion {
  login,
  signUp,
}

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthScreenVersion screenVersion = AuthScreenVersion.login;

  String _email;
  String _password;
  String _confirmPassword;

  void emailCallback(String value) => _email = value;
  void passwordCallback(String value) => _password = value;
  void confirmPasswordCallback(String value) => _confirmPassword = value;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message),
    );
  }

  void loginCallback() async {
    try {
      if (_email == null || _password == null) return;

      // Call init with email before logging in
      await Provider.of<Auth>(context).init(email: _email);
      await Provider.of<Auth>(context).authenticateUser(_password);
      await Provider.of<Auth>(context).getCognitoCredentials();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmAccountScreen(
              email: _email,
              password: _password,
            ),
          ),
        );
      } else {
        _showErrorDialog(e.message);
      }
    }
  }

  void signUpCallback() async {
    if (_email == null || _password == null || _confirmPassword == null) return;

    if (_password == _confirmPassword) {
      try {
        // call init with email before registering
        await Provider.of<Auth>(context).init(email: _email);
        await Provider.of<Auth>(context, listen: false).registerUser(_password);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmAccountScreen(
              email: _email,
              password: _password,
            ),
          ),
        );
      } catch (e) {
        _showErrorDialog(e.message);
      }
    }
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
                SizedBox(height: 15.0),
                AuthTextInput(
                  hintText: 'Email',
                  faIcon: FontAwesomeIcons.envelope,
                  callback: emailCallback,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15.0),
                AuthTextInput(
                  hintText: 'Password',
                  faIcon: FontAwesomeIcons.lock,
                  obscureText: true,
                  callback: passwordCallback,
                ),
                SizedBox(height: 15.0),
                screenVersion == AuthScreenVersion.login
                    ? Container()
                    : AuthTextInput(
                        hintText: 'Confirm Password',
                        faIcon: null,
                        callback: confirmPasswordCallback,
                        obscureText: true,
                      ),
                screenVersion == AuthScreenVersion.login
                    ? Container()
                    : SizedBox(height: 15.0),
                AuthButton(
                  buttonText: screenVersion == AuthScreenVersion.login
                      ? 'LOGIN'
                      : 'SIGN UP',
                  buttonColor: kButtonColor,
                  onPressed: screenVersion == AuthScreenVersion.login
                      ? loginCallback
                      : signUpCallback,
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Forgot Password'),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                    ),
                    SizedBox(width: 20.0),
                    FlatButton(
                      child: screenVersion == AuthScreenVersion.login
                          ? Text('Register Account')
                          : Text('Login'),
                      onPressed: () {
                        setState(() {
                          screenVersion =
                              screenVersion == AuthScreenVersion.login
                                  ? AuthScreenVersion.signUp
                                  : AuthScreenVersion.login;
                        });
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
