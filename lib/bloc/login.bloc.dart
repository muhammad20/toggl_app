import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toggl_app/core/base/bloc.dart';
import 'package:toggl_app/core/usecases/login/login.request.dart';
import 'package:toggl_app/core/usecases/login/login.usecase.dart';
import 'package:toggl_app/core/usecases/login/login.viewmodel.dart';
import 'package:toggl_app/data/persistence/shared-prefs-user-info.persistence.dart';
import 'package:toggl_app/data/web/repositories/users.repository.dart';
import 'package:toggl_app/utils/regex.dart';

class LoginBLoC implements IBLoC {
  BehaviorSubject<String> _emailFieldBehaviorSubject;
  Stream<String> get usernameStream => this._emailFieldBehaviorSubject.stream;

  BehaviorSubject<String> _passwordFieldBehaviorSubject;
  Stream<String> get passwordStream =>
      this._passwordFieldBehaviorSubject.stream;

  BehaviorSubject<bool> _isLoadingBehaviorSubject;
  Stream<bool> get isLoadingStream => _isLoadingBehaviorSubject.stream;

  TextEditingController passwordFieldController;
  TextEditingController emailFieldController;

  LoginBLoC() {
    this._emailFieldBehaviorSubject = BehaviorSubject<String>();
    this._passwordFieldBehaviorSubject = BehaviorSubject<String>();
    this._isLoadingBehaviorSubject = BehaviorSubject<bool>();
    this.passwordFieldController = TextEditingController();
    this.emailFieldController = TextEditingController();
  }

  Future<LoginViewModel> signIn() async {
    var response;
    if (_validateInput()) {
      try {
        _isLoadingBehaviorSubject.add(true);
        var usecase = LoginUseCase(
            UsersWebRepository(), SharedPrefsUerInfoPersistence.getInstance());
        response = await usecase
            .execute(LoginRequest(this.emailFieldController.text,
                this.passwordFieldController.text))
            .last;
        _isLoadingBehaviorSubject.add(false);
      } catch (e) {
        print(e);
        _isLoadingBehaviorSubject.add(false);
      }
    }
    return response;
  }

  bool _validateInput() {
    return _validateEmail() & _validatePassword();
  }

  bool _validateEmail() {
    String email = emailFieldController.text;
    RegExp emailRegex = TogglRegex.emailRegex;
    if (!emailRegex.hasMatch(email)) {
      _emailFieldBehaviorSubject.add('Enter a valid e-mail..');
      return false;
    }
    _emailFieldBehaviorSubject.add(null);
    return true;
  }

  bool _validatePassword() {
    String password = passwordFieldController.text;
    if (password.length < 8) {
      _passwordFieldBehaviorSubject
          .add('Password must be at least 8 characters..');
      return false;
    }
    _passwordFieldBehaviorSubject.add(null);
    return true;
  }

  @override
  void dispose() {
    _emailFieldBehaviorSubject.close();
    _passwordFieldBehaviorSubject.close();
    _isLoadingBehaviorSubject.close();
  }
}
