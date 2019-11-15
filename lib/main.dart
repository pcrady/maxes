import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maxes/screens/auth/change_password_screen.dart';
import 'package:maxes/screens/auth/login_screen.dart';
import 'package:maxes/screens/auth/forgot_password_screen.dart';
import 'package:maxes/screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:maxes/providers/auth.dart';
import 'package:maxes/screens/auth/confirm_account_screen.dart';
import 'package:maxes/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: MaterialApp(
        title: 'Maxes',
        home: FutureBuilderWidget(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
          ConfirmAccountScreen.routeName: (context) => ConfirmAccountScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
        },
      ),
    );
  }
}

class FutureBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).getCognitoCredentials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else {
          if (snapshot.error != null) {
            return LoginScreen();
          } else {
            return snapshot.data == null ? LoginScreen() : HomeScreen();
          }
        }
      },
    );
  }
}
