import 'package:flutter/material.dart';
import 'package:maxes/constants.dart';
import 'package:maxes/widgets/auth_button.dart';

class ErrorDialog extends StatelessWidget {

  String message;

  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'An Error Ocurred',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: new Offset(5.0, 5.0),
                    blurRadius: 20.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Text(message),
            SizedBox(height: 15.0),
            AuthButton(
              buttonText: 'OK',
              buttonColor: kButtonColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
