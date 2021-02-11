import 'package:flutter/material.dart';
import 'package:toggl_app/bloc/login.bloc.dart';
import 'package:toggl_app/presentation/login/login.screen.dart';
import 'package:toggl_app/utils/widgets/regular-button.widget.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5),
                  child: Text(
                    'Welcome to',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Raleway',
                        fontSize: 36.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Toggl App!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 5,
              ),
              child: TogglButton(
                Text(
                  'Sign In',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0),
                ),
                () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        LoginBLoC(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
