import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggl_app/core/usecases/login/login.request.dart';
import 'package:toggl_app/core/usecases/login/login.usecase.dart';
import 'package:toggl_app/core/usecases/login/login.viewmodel.dart';
import 'package:toggl_app/data/persistence/shared-prefs-user-info.persistence.dart';
import 'package:toggl_app/data/web/repositories/users.repository.dart';
import 'package:toggl_app/presentation/home/home.screen.dart';
import 'package:toggl_app/presentation/welcome/welcome.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stream<LoginViewModel> stream = LoginUseCase(
          UsersWebRepository(), SharedPrefsUerInfoPersistence.getInstance())
      .execute(LoginRequest('', ''));
  // var pers = SharedPrefsUerInfoPersistence.getInstance().deleteUserInfo();
  runApp(TogglMobileApp(stream));
}

class TogglMobileApp extends StatelessWidget {
  final Stream<LoginViewModel> _stream;
  TogglMobileApp(this._stream);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toggl App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF1565C0),
      ),
      home: StreamBuilder<LoginViewModel>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('An error occured please re-open the application'),
              );
            }
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.data.apiToken == null) {
              return WelcomeScreen();
            }
            return HomeScreen(snapshot.data);
          }),
    );
  }
}
