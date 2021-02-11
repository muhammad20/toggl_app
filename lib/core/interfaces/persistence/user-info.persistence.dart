// Dart imports
import 'dart:async';

import 'package:toggl_app/core/entities/user.dart';

abstract class IUserInfoPersistence {
  Future<bool> saveUserInfo(User user); 
  Future<User> getUserInfo();
  Future<bool> deleteUserInfo();
}