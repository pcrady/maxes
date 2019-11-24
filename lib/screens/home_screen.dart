import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maxes/constants.dart';
import 'package:maxes/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:maxes/widgets/auth_button.dart';
import "package:maxes/screens/auth/login_screen.dart";
import 'package:maxes/widgets/error_dialog.dart';
import 'package:maxes/screens/auth/change_password_screen.dart';
import 'package:maxes/secrets.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _serverText = 'This will come from the server';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: kBackgroundConfig,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _serverText,
              textAlign: TextAlign.center,
              style: kBigTextStyle,
            ),
            SizedBox(height: 15.0),
            AuthButton(
              buttonText: 'GET DATA FROM SERVER',
              buttonColor: Color(0xffff1ba9),
              onPressed: () async {
                http.Response response;

                try {
                  CognitoCredentials credentials = await Provider.of<Auth>(context).getCognitoCredentials();

                  final awsSigV4Client = AwsSigV4Client(
                    credentials.accessKeyId,
                    credentials.secretAccessKey,
                    Secrets.apiGatewayEndpoint,
                    sessionToken: credentials.sessionToken,
                    region: Secrets.region,
                  );

                  final signedRequest = SigV4Request(
                    awsSigV4Client,
                    method: 'GET',
                    path: '/test',
                  );

                  response = await http.get(
                    signedRequest.url,
                    headers: signedRequest.headers,
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ErrorDialog(message: e.toString()),
                  );
                }
                setState(() {
                  _serverText = response.body;
                });
              },
            ),
            SizedBox(height: 15.0),
            AuthButton(
              buttonText: 'CHANGE PASSWORD',
              buttonColor: kButtonColor,
              onPressed: () {
                Navigator.pushNamed(context, ChangePasswordScreen.routeName);
              },
            ),
            SizedBox(height: 15.0),
            AuthButton(
              buttonText: 'LOG OUT',
              buttonColor: kButtonColor,
              onPressed: () async {
                try {
                  await Provider.of<Auth>(context).signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ErrorDialog(message: e.toString()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
