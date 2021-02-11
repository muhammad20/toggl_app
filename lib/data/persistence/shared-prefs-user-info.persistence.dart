import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggl_app/core/entities/user.dart';
import 'package:toggl_app/core/interfaces/persistence/user-info.persistence.dart';
import 'package:toggl_app/data/web/base/token-provider.dart';

class SharedPrefsUerInfoPersistence
    implements ITokenProvider, IUserInfoPersistence {

  final String _userInfoKey = 'user_info';

  /// Singleton
  static SharedPrefsUerInfoPersistence _instance;

  SharedPrefsUerInfoPersistence._();

  static SharedPrefsUerInfoPersistence getInstance() {
    if (_instance == null) {
      _instance = SharedPrefsUerInfoPersistence._();
    }
    return _instance;
  }

  @override
  Future<String> getToken() async {
    try {
      var user = await this.getUserInfo();
      if (user == null) {
        return null;
      }
      return user.accessToken;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> getUserInfo() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      String jsonString = sharedPreferences.getString(this._userInfoKey);
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      var toReturn =
          new User(jsonMap['fullName'], jsonMap['accessToken'], jsonMap['email']);

      return toReturn;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveUserInfo(User user) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      bool isSaved = await sharedPreferences.setString(
          this._userInfoKey, this._userToString(user));
      return isSaved;
    } catch (e) {
      return false;
    }
  }

  String _userToString(User userInfo) {
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['accessToken'] = userInfo.accessToken;
    jsonMap['fullName'] = userInfo.fullName;
    jsonMap['email'] = userInfo.email;
    var string = json.encode(jsonMap);
    return string;
  }

  @override
  Future<bool> deleteUserInfo() async {
    try {
      var sharedPrefsInstance = await SharedPreferences.getInstance();
      var success = sharedPrefsInstance.remove(this._userInfoKey);
      var data = sharedPrefsInstance.getString(this._userInfoKey);
      print(data);
      return success;
    } catch(e) {
      print('failed to clear');
      return false;
    }
  }
}
