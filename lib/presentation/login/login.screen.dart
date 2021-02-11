import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggl_app/bloc/login.bloc.dart';
import 'package:toggl_app/core/usecases/login/login.viewmodel.dart';
import 'package:toggl_app/presentation/home/home.screen.dart';
import 'package:toggl_app/utils/widgets/regular-button.widget.dart';
import 'package:toggl_app/utils/widgets/text-field.widget.dart';

class LoginScreen extends StatelessWidget {
  final LoginBLoC _bloc;

  LoginScreen(this._bloc);

  void _dispose() {
    this._bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 5,
            horizontal: MediaQuery.of(context).size.width / 10,
          ),
          child: Column(
            children: [
              Text(
                'Toggl App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                child: TogglInputField(
                  'Username',
                  'enter your username..',
                  _bloc.usernameStream,
                  _bloc.emailFieldController,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 30),
                child: TogglInputField(
                  'Password',
                  'Enter your password..',
                  _bloc.passwordStream,
                  _bloc.passwordFieldController,
                  obscureText: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8),
                child: StreamBuilder<bool>(
                  stream: _bloc.isLoadingStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null || !snapshot.data) {
                      return TogglButton(
                          Text(
                            'Confirm',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                          ), () async {
                        LoginViewModel loginViewModel = await _bloc.signIn();
                        if (loginViewModel.apiToken != null) {
                          this._dispose();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(loginViewModel),
                            ),
                          );
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'An Error has occured!',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14.0,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    } else {
                      return TogglButton(
                        Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(),
                        () {},
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
