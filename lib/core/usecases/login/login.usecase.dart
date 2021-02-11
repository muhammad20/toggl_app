import 'dart:async';
import 'package:toggl_app/core/base/usecase.dart';
import 'package:toggl_app/core/entities/user.dart';
import 'package:toggl_app/core/interfaces/persistence/user-info.persistence.dart';
import 'package:toggl_app/core/interfaces/repositories/users.repository.dart';
import 'package:toggl_app/core/usecases/login/login.request.dart';
import 'package:toggl_app/core/usecases/login/login.viewmodel.dart';

class LoginUseCase implements IUseCase<LoginRequest, LoginViewModel> {
  IUsersRepository _repository;
  IUserInfoPersistence _persistence;

  LoginUseCase(this._repository, this._persistence);

  @override
  Stream<LoginViewModel> execute(input) {
    StreamController<LoginViewModel> controller =
        StreamController<LoginViewModel>();
    this._getUserInfo(input.email, input.password).then((loginViewModel) {
      controller.add(loginViewModel);
      controller.close();
    }).catchError((e) {
      controller.close();
    });
    return controller.stream;
  }

  Future<LoginViewModel> _getUserInfo(String email, String password) async {
    User user;
    try {
      user = await this._persistence.getUserInfo();
    } catch (e) {
      user = null;
    }

    // if an error occured while saving to shared prefs, delete data to re-save it.
    if (user != null && (user.fullName == null || user.accessToken == null)) {
      var isDeleted = await this._persistence.deleteUserInfo();
      if (!isDeleted) {
        throw Exception('Error!');
      }
    }

    if (user == null) {
      try {
        user = await this._repository.login(email, password).last;
      } catch (e) {
        print(e);
      }
    }

    if (user == null) {
      return LoginViewModel(null, null, null);
    }

    this._persistence.saveUserInfo(user).catchError((e) => print(e));
    return LoginViewModel(user.fullName, user.accessToken, email);
  }
}
